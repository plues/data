#!/usr/bin/env python
import random
from datetime import datetime
import argparse
import sys


SLOTS = [l+n for n in "12345" for l in "abcdefg"]

MAX_GROUPS = 4
MAX_FOCUS_AREAS = 10
MAX_MODULES = 10
MAPPINGS = 50
MAX_SESSIONS = 5

class Session(object):
    def __init__(self, idx, slot, rhythm, duration):
        self.slot = slot
        self.rhythm = rhythm
        self.duration = duration
        self.idx = idx
        self.group_idx = -1

    def __repr__(self):
        return "Session({idx}, '{slot}', {rhythm}, {duration})".format(**self.__dict__)

    def __sql__(self):
        # XXX group insertions (faster)
        return """INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES ({idx}, {group_idx}, "{slot}", {rhythm}, {duration}, datetime("now"), datetime("now"));""".format(**self.__dict__)


class Group(object):
    def __init__(self, idx, title, sessions, unit_idx=None):
        self.idx = idx
        self.title = title
        self.sessions = sessions
        self.unit_idx = -1
        if unit_idx:
            self.unit_idx = unit_idx
        for s in sessions:
            assert s.group_idx == -1
            s.group_idx = self.idx

    def __repr__(self):
        return "Group({idx}, '{title}', {sessions}, unit={unit})".format(**self.__dict__)

    def __sql__(self):
        # XXX group insertions (faster)
        _sql = ["""INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES ({idx}, {unit_idx}, "{title}", datetime("now"), datetime("now"));"""
                .format(**self.__dict__)] \
                                + [sql(s) for s in self.sessions]
        return '\n'.join(_sql)


class Unit(object):
    def __init__(self, idx, title, department, duration=0, groups=None):
        self.idx = idx
        self.title = title
        self.department = department
        self.duration = duration
        if groups == None:
            groups = []
        self.groups = groups
        for g in groups:
            assert g.unit_idx == -1
            g.unit_idx = self.idx

    def __repr__(self):
        return """Unit(idx={idx}, title='{title}', department='{department}', duration={duration}, groups={groups})""".format(**self.__dict__)

    def __sql__(self):
        return '\n'.join(["""INSERT INTO units (id, title, department_id, duration, created_at, updated_at) VALUES ({idx}, "{title}", {department.idx}, {duration}, datetime("now"), datetime("now"));""".format(**self.__dict__), sql(*self.groups)])


class NamedThing(object):

    def __init__(self, idx, name):
        self.name = name
        self.idx = idx
        self.table_name = self.table_name # because reasons

    def __repr__(self):
        return """{cls.__name__}({fields})""".format(cls=self.__class__, fields=self.__dict__)

    def __sql__(self):
        raise NotImplementedError


class Module(NamedThing):
    table_name = "modules"

    def __init__(self, idx, name, course, typ, focus_areas):
        NamedThing.__init__(self, idx, name)
        self.course = course
        self.typ = typ
        self.focus_areas = focus_areas

    def __sql__(self):
        _sql = [
            """INSERT INTO {table_name} (id, name, created_at, updated_at) VALUES ({idx}, "{name}", datetime("now"), datetime("now"));
--- NOTE: each module is assigned to one course for now
INSERT INTO courses_modules(module_id, course_id, elective_units, type) VALUES ({idx}, {course.idx}, 3, "{typ}");
""".format(**self.__dict__)
        ] + ["""INSERT INTO modules_focus_areas (module_id, focus_area_id)
                VALUES({module_id}, {focus_area_id});""".format(module_id=self.idx,
                    focus_area_id=fa.idx) for fa in self.focus_areas]
        return '\n'.join(_sql)


class FocusArea(NamedThing):
    table_name = "focus_areas"

    def __sql__(self):
        return """INSERT INTO {table_name} (id, name, created_at, updated_at) VALUES ({idx}, "{name}", datetime("now"), datetime("now"));""".format(**self.__dict__)


class Course(NamedThing):
    table_name = "courses"

    def __init__(self, idx, name, long_name):
        NamedThing.__init__(self, idx, name)
        self.long_name = long_name

    def __sql__(self):
        return """
INSERT INTO {table_name} (id, name, long_name, elective_modules, created_at, updated_at) VALUES ({idx}, "{name}", "{long_name}", 3, datetime("now"), datetime("now"));""".format(**self.__dict__)


class Department(NamedThing):
    table_name = "departments"

    def __init__(self, idx, name, long_name):
        NamedThing.__init__(self, idx, name)
        self.long_name = long_name

    def __sql__(self):
        return """INSERT INTO {table_name} (id, name, long_name, created_at, updated_at) VALUES ({idx}, "{name}", "{long_name}", datetime("now"), datetime("now"));""".format(**self.__dict__)


class Mapping(object):
    def __init__(self, course, module, unit, typ, semesters):
        self.module = module
        self.course = course
        self.typ = typ
        self.semesters = semesters
        self.unit = unit

    def __repr__(self):
        return """Mapping({course}, {module}, {unit}, "{typ}", {semesters})""".format(**self.__dict__)
    def __sql__(self):
        _sql = ("INSERT INTO courses_modules_units(course_id, module_id, unit_id, semester, type) "
                'VALUES ({course.idx}, {module.idx}, {unit.idx}, {semester}, "{typ}");'
                    .format(semester=s, **self.__dict__) for s in self.semesters)
        return '\n'.join(_sql)


def session_generator():
    idx = 0
    while True:
        idx += 1
        slot = random.choice(SLOTS)
        # XXX add weights?
        rhythm = random.randint(0, 2)
        duration = 2
        yield Session(idx, slot, rhythm, duration)


def group_generator(sg):
    idx = 0
    while True:
        idx += 1
        title = "Group "+str(idx)
        sessions = [next(sg) for _ in range(random.randint(1, MAX_SESSIONS))]
        yield Group(idx, title, sessions)


def unit_generator(gg, departments):
    idx = 0
    while True:
        idx += 1
        title = "Unit "+str(idx)
        department = random.choice(departments)
        groups = [next(gg) for _ in range(1, MAX_GROUPS)]
        yield Unit(idx, title, department, groups=groups)


def module_generator(name, courses, focus_areas):
    idx = 0
    while True:
        course = random.choice(courses)
        fa = random.sample(focus_areas, random.choice((0, len(focus_areas))))
        idx += 1
        yield Module(idx, name + "_" + str(idx), course, random.choice(('m', 'e')), fa)


def name_generator(name, cls):
    idx = 0
    while True:
        idx += 1
        yield cls(idx, name + "_" + str(idx))


def mapping_generator(ug, courses, modules, focus_areas):
    course = random.choice(courses)
    while True:
        typ = random.choice(('e', 'm'))
        if typ == 'm':
            semesters = [random.choice(range(1, 7))]
        else:
            semesters = random.sample(
                    range(random.choice((1,2)), 7, 2), # list of or odd semesters
                    random.randint(1,3) # number of elements to sample 1..3
                    ) # select n odd or even semesters
        unit = next(ug)
        module = random.choice(modules)
        yield Mapping(course, module, unit, typ, semesters)


def sql(*args):
    acc = []
    for i in args:
        acc.append(i.__sql__())
    return '\n'.join(acc)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--seed', help="Seed for the pseudo-random number generator",
                        type=int)
    parser.add_argument('--output', help="path to output file", default=sys.stdout,
                        type=argparse.FileType('w'))

    args =  parser.parse_args()

    if args.seed is None:
        print("Initializing random seed")
        args.seed = random.randint(0, sys.maxsize)
    return args


def main():
    args = parse_args()
    random.seed(args.seed)
    print("Random seed:", args.seed)

    courses = [Course(1, "Course", "This is for testing")]
    departments = [Department(1, "Dep", "This is for testing")]
    #
    sg = session_generator()
    gg = group_generator(sg)
    ug = unit_generator(gg, departments)

    #
    fg = name_generator("Focus_Area", FocusArea)
    focus_areas = [next(fg) for _ in range(random.randint(1, MAX_FOCUS_AREAS))]
    print("created {n} focus_areas".format(n=len(focus_areas)))
    #
    mg = module_generator("Module", courses, focus_areas)
    modules = [next(mg) for _ in range(random.randint(1, MAX_MODULES))]
    print("created {n} modules".format(n=len(modules)))
    #

    # mappings
    mapping = mapping_generator(ug, courses, modules, focus_areas)
    mappings = [next(mapping) for _ in range(MAPPINGS)]
    #
    units = {m.unit for m in mappings}
    print("created {n} units".format(n=len(units)))

    print('.read "schema.sql"', file=args.output)
    print('INSERT INTO "info" values("generated", "{generated:%Y-%m-%d %H:%M:%S}");'.format(generated=datetime.now()), file=args.output)
    print('INSERT INTO "info" values("random seed", "{seed}");'.format(seed=args.seed), file=args.output)
    print('INSERT INTO "info" values("generator", "random");', file=args.output)
    #
    print(sql(*courses), file=args.output)
    print(sql(*departments), file=args.output)
    print(sql(*modules), file=args.output)
    print(sql(*focus_areas), file=args.output)
    print(sql(*list(units)), file=args.output)
    print(sql(*mappings), file=args.output)


if __name__ == '__main__':
    main()
