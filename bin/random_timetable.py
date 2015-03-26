#!/usr/bin/env python
import random
from datetime import datetime
import argparse
import sys


SLOTS = [l+n for n in "12345" for l in "abcdefg"]

class Session(object):
    def __init__(self, idx, slot, rhythm, duration):
        self.slot = slot
        self.rhythm = rhythm
        self.duration = duration
        self.idx = idx

    def __repr__(self):
        return "Session({idx}, '{slot}', {rhythm}, {duration})".format(**self.__dict__)

    def __sql__(self):
        # XXX group insertions (faster)
        return """INSERT INTO "sessions" (id, slot, rhythm, duration, created_at, updated_at) VALUES ({idx}, "{slot}", {rhythm}, {duration}, datetime("now"), datetime("now"));""".format(**self.__dict__)


class Group(object):
    def __init__(self, idx, title, sessions, unit_idx=None):
        self.idx = idx
        self.title = title
        self.sessions = sessions
        self.unit_idx = -1
        if unit_idx:
            self.unit_idx = unit_idx

    def __repr__(self):
        return "Group({idx}, '{title}', {sessions}, unit={unit})".format(**self.__dict__)

    def __sql__(self):
        # XXX group insertions (faster)
        _sql = ["""INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES ({idx}, {unit_idx}, "{title}", datetime("now"), datetime("now"));"""
                .format(**self.__dict__)]
        for s in self.sessions:
            _sql.append(sql(s))
            _sql.append("""INSERT INTO group_sessions (group_id, session_id) VALUES ({gidx}, {sidx});"""
                    .format(gidx=self.idx,
                        sidx=s.idx))
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
        return '\n'.join(["""INSERT INTO units (id, title, department, duration, created_at, updated_at) VALUES ({idx}, "{title}", "{department.name}", {duration}, datetime("now"), datetime("now"));""".format(**self.__dict__), sql(*self.groups)])


class NamedThing(object):

    def __repr__(self):
        return """{cls.__name__}({fields})""".format(cls=self.__class__, fields=self.__dict__)

    def __sql__(self):
        raise NotImplementedError


class Module(NamedThing):
    table_name = "modules"
    def __init__(self, idx, name):
        self.name = name
        self.table_name = self.table_name  # because reasons

    def __sql__(self):
        return """INSERT INTO {table_name} (name, created_at, updated_at) VALUES ("{name}", datetime("now"), datetime("now"));""".format(**self.__dict__)


class FocusArea(NamedThing):
    table_name = "focus_areas"

    def __init__(self, idx, name):
        self.idx = idx
        self.name = name
        self.table_name = self.table_name  # because reasons

    def __sql__(self):
        return """INSERT INTO {table_name} (id, name, created_at, updated_at) VALUES ({idx}, "{name}", datetime("now"), datetime("now"));""".format(**self.__dict__)


class Course(NamedThing):
    table_name = "courses"

    def __init__(self, name, long_name):
        self.name = name
        self.long_name = long_name
        self.table_name = self.table_name  # because reasons

    def __sql__(self):
        return """
INSERT INTO {table_name} (name, long_name, created_at, updated_at) VALUES ("{name}", "{long_name}", datetime("now"), datetime("now"));
INSERT INTO major_module_requirements (course, requirement) VALUES ("{name}", 3);""".format(**self.__dict__)


class Department(Course):
    table_name = "departments"
    def __sql__(self):
        return """
INSERT INTO {table_name} (name, long_name, created_at, updated_at) VALUES ("{name}", "{long_name}", datetime("now"), datetime("now"));""".format(**self.__dict__)


class Mapping(object):
    def __init__(self, module, klass, course, typ, focus_area, semester, unit):
        self.module = module
        self.klass = klass
        self.course = course
        self.typ = typ
        self.focus_area = focus_area
        self.semester = semester
        self.unit = unit

    def __repr__(self):
        return """Mapping({module}, {klass}, "{course}", "{typ}", {focus_area}, {semester}, {unit})""".format(**self.__dict__)
    def __sql__(self):
        return """insert into mapping ("module", "class", "course", "type", "focus_area_id", "semester", "unit_id") VALUES ("{module.name}", {klass}, "{course.name}", "{typ}", {focus_area.idx}, {semester}, {unit.idx});""".format(**self.__dict__)



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
        sessions = [next(sg) for _ in range(random.randint(1, 5))]
        yield Group(idx, title, sessions)


def unit_generator(gg, departments):
    idx = 0
    while True:
        idx += 1
        title = "Unit "+str(idx)
        department = random.choice(departments)
        groups = [next(gg) for _ in range(1,8)]
        yield Unit(idx, title, department, groups=groups)


def name_generator(name, cls):
    idx = 0
    while True:
        idx += 1
        yield cls(idx, name + "_" + str(idx))


def mapping_generator(ug, courses, modules, focus_areas):
    course = random.choice(courses)
    while True:
        typ = random.choice(('P', 'W'))
        semesters = random.sample(
                range(random.choice((1,2)), 7, 2), # list of or odd semesters
                random.randint(1,3) # number of elements to sample 1..3
                ) # select n odd or even semesters
        unit = next(ug)
        module = random.choice(modules)
        focus_area = random.choice(focus_areas)
        for s in semesters:
            yield Mapping(module, 1, course, typ, focus_area, s, unit)


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

    courses = [Course("Course", "This is for testing")]
    departments = [Department("Dep", "This is for testing")]
    #
    sg = session_generator()
    gg = group_generator(sg)
    ug = unit_generator(gg, departments)

    mg = name_generator("Module", Module)
    fg = name_generator("Focus Area", FocusArea)

    #
    modules = [next(mg) for _ in range(random.randint(1, 100))]
    print("created {n} modules".format(n=len(modules)))

    focus_areas = [next(fg) for _ in range(random.randint(1, 15))]
    print("created {n} focus_areas".format(n=len(focus_areas)))
    #
    mapping = mapping_generator(ug, courses, modules, focus_areas)
    mappings = [next(mapping) for _ in range(100)]
    #
    units = {m.unit for m in mappings}
    print("created {n} units".format(n=len(units)))

    print('.read "schema.sql"', file=args.output)
    print('INSERT INTO "info" values("generated", "{generated:%Y-%m-%d %H:%M:%S}");'.format(generated=datetime.now()), file=args.output)
    print('INSERT INTO "info" values("hashseed", "{seed}");'.format(seed=args.seed), file=args.output)
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
