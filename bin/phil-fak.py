#!/usr/bin/env python
import os
import pandas
import argparse

from datetime import datetime

from util import rcprint, cprint


DEFAULT_MODULE = "MODULE"

SQL = u"""
.read "schema.sql"

INSERT INTO "info" values("generated", "{generated:%Y-%m-%d %H:%M:%S}");
INSERT INTO "info" values("hashseed", "{seed}");
INSERT INTO "info" values("generator", "phil-fak");

INSERT INTO "departments" (name, long_name, created_at, updated_at) VALUES
        {departments};

INSERT INTO "modules" (name, created_at, updated_at) VALUES ("MODULE", datetime('now'), datetime('now'));

INSERT INTO "courses" (name, created_at, updated_at) VALUES
        {courses};

INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        {sessions};

INSERT INTO "units" (id, title, department_id, created_at, updated_at) VALUES
        {units};

INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        {groups};

INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        {courses_modules};

-- generates too many records for a single insert statement
""";

def extract_key(row):
    title = row['title']
    title = title.lower().strip()
    if '(' in title and row['department'] != 'ang':
        title = title[:title.index('(')]
    title = title.strip()
    title = title.replace(":", " ")
    title = title.replace("-", " ")
    if title.startswith("grundkurs"):
        title = title.split(' ')[0]
    title = title.replace(" ", "")
    title = hash(title)
    semester = row['semester'] % 2
    return (row['department'], semester, title)

default_departments = {"ang": "Anglistik",
                        "ger": "Germanistik",
                        "jap": "Modernes Japan",
                        "jud": "Jüdische Studien",
                        "jid": "Jiddistik",
                        "kom": "Kommunikationswissenschaften",
                        "lin": "Linguistik",
                        "pol": "Politologie",
                        "rom": "Romanistik",
                        "soz": "Soziologie",
                        "ges": "Geschichte",
                        "inf": "Informationswissenschaften",
}




def extract_departments(csv):
    departments = {k:'' for k in csv['department'].unique()}
    departments.update(default_departments)
    return departments

def extract_courses(csv):
    kfs   = csv[csv.kf]['course'].unique()
    efs   = csv[csv.ef]['course'].unique()
    integ = csv[csv['is']]['course'].unique()
    combined = {'{kf}_{ef}'.format(kf=kf, ef=ef)
                                        for kf in kfs
                                            for ef in efs
                                                if kf != ef}
    return combined.union(integ)

def group_counter():
    i = 0
    while True:
        i += 1
        yield i


def extract_groups(department, title, rows):
    groups = {'kf':{}, 'ef':{}}
    group_id = {'kf':group_counter(), 'ef':group_counter()}
    # we need to group the rows here which might be several version of the
    # same unit but assigned to different "coures", i.e. assigned to sowi and kom
    for _ ,rowgroup in rows.groupby('slot', axis=0):
        # XXX sanity check
        row = rowgroup.irow(0)
        group = row['group']
        kf = row['kf']
        ef = row['ef']
        kind = 'kf' if kf else 'ef'
        title = row['title']
        if group == 0:
            group = next(group_id[kind])
        if group not in groups[kind]:
            groups[kind].setdefault(group, {'title':title, 'sessions':{}})
        sessions = groups[kind][group]['sessions']
        if row['slot'] in sessions: # sanity check for same session
            session = sessions[row['slot']]
            assert session['slot'] == row['slot']
            assert session['department'] == department
            assert session['title'] == title
        else:
            sessions[row['slot']] = {'slot':row['slot'], 'department':department, 'title': title}
    slots = {key: sorted((session['slot'] for group in groups[key].values() for session in group['sessions'].values())) for key in ('kf', 'ef')}
    if len(slots['kf']) == 0:
        assert len(slots['ef']) > 0
        return groups['ef']
    if len(slots['ef']) == 0:
        assert len(slots['kf']) > 0
        return groups['kf']
    assert slots['kf'] == slots['ef']
    return groups['kf']


def extract_units(data):
    units = []
    map = {}
    for i, rows in data:
        title = rows.iloc[0]['title']
        department = rows.iloc[0]['department']
        key = rows.iloc[0]['key']
        groups = extract_groups(department, title, rows)
        units.append({'title':title, 'department':department, 'groups':groups})
        map[key] = len(units) - 1
    return units, map


def extract_sessions(units):
    """Extract a global list of sessions from units and map each session in a
    module/group to the index in the list of sessions"""
    sessions = []
    for m in units:
        for i in m['groups']:
            start = len(sessions)
            for s in m['groups'][i]['sessions'].values():
                sessions.append(s)
            m['groups'][i]['sessions'] = list(range(start, len(sessions)))
    return sessions


def extract_mapping(rows, map):
    mapping = set()
    semesters = rows['semester'].unique()
    kfs   = rows[rows.kf]['course'].unique()
    efs   = rows[rows.ef]['course'].unique()
    integ = rows[rows['is']]['course'].unique()
    rowmap = {}
    for s in semesters:
        for kf in kfs:
            for ef in efs:
                if kf == ef:
                    continue
                kfrows = rowmap.setdefault((kf, 'kf', s),
                            rows[(rows.semester == s) & (rows.course == kf) & (rows.kf)])
                efrows = rowmap.setdefault((ef, 'ef', s),
                            rows[(rows.semester == s) & (rows.course == ef) & (rows.ef)])
                course = '{kf}_{ef}'.format(kf=kf, ef=ef)
                for _rows in (kfrows, efrows):
                    for _, row in _rows.iterrows():
                        mapping.add((course, row['department'], s, map[row['key']]))
        for i in integ:
            for _, row in rows[(rows.semester == s) & (rows.course == i) & (rows['is'])].iterrows():
                mapping.add((i, row['department'], s, map[row['key']]))
    return mapping


FORMATS={
    "sql": {
        'SESSION': '({id}, {group_id}, "{slot}", 0, 2, datetime("now"), datetime("now"))',
        'DEPARTMENT': '("{name}", "{long_name}", datetime("now"), datetime("now"))',
        'COURSE': '("{name}", datetime("now"), datetime("now"))',
        'SEPARATOR': ',\n'+' '*8,
        'UNIT': '({id}, "{title}", (SELECT id from departments WHERE name LIKE "{department}"), datetime("now"), datetime("now"))',
        'GROUP': '({id}, {unit_id}, "{title}", datetime("now"), datetime("now"))',
        'MAPPING': 'INSERT INTO "mapping" (module, course, semester, unit_id) VALUES ((SELECT name FROM modules LIMIT 1), "{course}", {semester}, {unit});',
        'COURSES_MODULES': '((SELECT id FROM courses WHERE name LIKE "{course}"), (SELECT id FROM modules LIMIT 1), "m")'
    },
}

def gen_sql(courses, departments, units, mapping):
    f = FORMATS['sql']

    formatted_courses = f['SEPARATOR'].join(f['COURSE'].format(name=c) for c in courses)
    formatted_courses_modules = f['SEPARATOR'].join(f['COURSES_MODULES'].format(course=c) for c in courses)
    formatted_departments =  f['SEPARATOR'].join(f['DEPARTMENT'].format(name=k, long_name=v) for (k,v) in departments.items())

    seed = os.environ.get('PYTHONHASHSEED', 'not specified')
    formatted_units = []
    formatted_groups = []
    formatted_sessions = []

    for u_id, unit in enumerate(units, 1):
        formatted_units.append(f['UNIT'].format(id=u_id,
            title=unit['title'],
            department=unit['department']))
        for _, group in unit['groups'].items():
            group_id = len(formatted_groups)+1
            formatted_group = f['GROUP'].format(id=group_id, unit_id=u_id,
                    title=group['title'])
            formatted_groups.append(formatted_group)
            for i in group['sessions'].values():
                session_id = len(formatted_sessions)+1
                formatted_sessions.append(f['SESSION'].format(group_id=group_id, id=session_id, **i))

    formatted_groups = f['SEPARATOR'].join(formatted_groups)
    formatted_sessions = f['SEPARATOR'].join(formatted_sessions)
    formatted_units = f['SEPARATOR'].join(formatted_units)
    formatted_mapping = '\n'.join(f['MAPPING'].format(course=m[0],
        department=m[1], semester=m[2], unit=m[3]+1) for m in mapping)

    return SQL.format(generated=datetime.now(), seed=seed,
            sessions=formatted_sessions, courses=formatted_courses,
            units=formatted_units, groups=formatted_groups,
            departments=formatted_departments,
            courses_modules=formatted_courses_modules,
            mapping=formatted_mapping)


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('input', help="path to input file",
                        type=argparse.FileType('r'))
    parser.add_argument('output', help="path to output file",
                        type=argparse.FileType('w'))

    args = parser.parse_args()
    rcprint("Loading input from " + args.input.name)
    csv = pandas.read_csv(args.input, encoding='utf-8', header=None, names=['course','department', 'semester','slot', 'module', 'group', 'title'])
    csv = csv.rename(columns=dict(enumerate(['course', 'semester', 'slot', 'module', 'group', 'title'])))
    csv['kf'] = csv['course'].str.lower().map(lambda x: x[-2:] == 'kf')
    csv['ef'] = csv['course'].str.lower().map(lambda x: x[-2:] == 'ef')
    csv['is'] = csv['course'].str.lower().map(lambda x: x[-2:] == 'is')
    csv['department'] = csv['department'].str.lower()

    csv['title'] = csv['title'].str.strip().map(lambda x: x.replace('"', "'"))
    csv['course'] = csv['course'].str.lower().map(lambda x: x[:-2])
    csv['slot'] = csv['slot'].str.lower()
    csv['key'] = csv.apply(extract_key, axis=1)
    rcprint("Normalized input")

    courses = extract_courses(csv)
    rcprint("Extracted course information")
    departments = extract_departments(csv)
    rcprint("Extracted department information")
    units, map = extract_units(csv.groupby('key', axis=0))
    rcprint("Extracted module/unit information")
    # sessions = extract_sessions(units)
    rcprint("Extracted session information")
    mapping = extract_mapping(csv, map)
    rcprint("Extracted mapping information")

    rcprint("Generating sql file")
    print(gen_sql(courses, departments, units, mapping), file=args.output)
    print()

    cprint("Done: Output written to " + args.output.name, 'green')


if __name__ == '__main__':
    main()
