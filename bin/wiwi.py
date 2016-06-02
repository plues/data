#!/usr/bin/env python
import argparse
import numpy
import os
import pandas
import sys

from datetime import datetime

from util import rcprint, cprint

seed = os.environ.get('PYTHONHASHSEED', 'not specified')


SQL = u"""
.read "schema.sql"

INSERT INTO "info" values("generated", "{generated:%Y-%m-%d %H:%M:%S}");
INSERT INTO "info" values("hashseed", "{seed}");
INSERT INTO "info" values("generator", "wiwi");

INSERT INTO "departments"(name, long_name, created_at, updated_at) VALUES ("wiwi", "Wirtschaftswissenschaften", datetime('now'), datetime('now'));

INSERT INTO "courses" (name, long_name, elective_modules,  created_at, updated_at) VALUES
       ("bwl_bachelor",               "BWL Bachelor", 3, datetime('now'),  datetime('now')),
         ("bwl_master",                 "BWL Master", 2, datetime('now'),  datetime('now')),
       ("vwl_bachelor",               "VWL Bachelor", 3, datetime('now'),  datetime('now')),
         ("vwl_master",                 "VWL Master", 2, datetime('now'),  datetime('now')),
    ("wichem_bachelor", "Wirtschaftschemie Bachelor", 3, datetime('now'),  datetime('now')),
      ("wichem_master",   "Wirtschaftschemie Master", 2, datetime('now'), datetime('now'));

INSERT INTO "focus_areas" (id, name, created_at, updated_at) VALUES
         (1,        "Accounting and Taxation", datetime('now'), datetime('now')),
         (2,                        "Finance", datetime('now'), datetime('now')),
         (3,            "Unternehmensführung", datetime('now'), datetime('now')),
         (4, "Europäische Wirtschaftspolitik", datetime('now'), datetime('now')),
         (5,     "Neue Institutionenökonomie", datetime('now'), datetime('now')),
         (6,            "Wettbewerbsökonomik", datetime('now'), datetime('now')),
         (7,        "Accounting and Taxation", datetime('now'), datetime('now')),
         (8,                        "Finance", datetime('now'), datetime('now')),
         (9,     "Human Resources Management", datetime('now'), datetime('now')),
        (10,            "Unternehmensführung", datetime('now'), datetime('now')),
        (11,               "Entrepreneurship", datetime('now'), datetime('now')),
        (12,                   "Finanzmärkte", datetime('now'), datetime('now')),
        (13,     "Wettbewerb und Regulierung", datetime('now'), datetime('now')),
        (14,                   "Econometrics", datetime('now'), datetime('now'));

INSERT INTO "modules" (name, frequency, created_at, updated_at) VALUES
        {modules};

INSERT INTO "sessions" (id, group_id, slot, rhythm, duration, created_at, updated_at) VALUES
        {sessions};

INSERT INTO "units" (id, title, duration, department_id, created_at, updated_at) VALUES
        {units};

INSERT INTO "groups" (id, unit_id, title, created_at, updated_at) VALUES
        {groups};


INSERT INTO "courses_modules" (course_id, module_id, type) VALUES
        {courses_modules};

-- generates too many records for a single insert statement
{modules_focus_areas}

{courses_modules_units}
"""


def normalized_title(row):
    title = row['Veranstaltungstitel']
    if '(' in title:
        title = title[:title.index('(')].strip()
    title = title.lower()
    return hash(title + row['Angebot'])


def extract_modules(data):
    modules = {}
    for i, row in data.iterrows():
        name = row['Modul']
        if name not in modules:
            modules[name] = {}
        module = modules[name]

        if 'courses' not in module:
            module['courses'] = set()

        module['name'] = name
        module['frequency'] = row['Angebot']
        module['type'] = 'm' if row['Modultyp'] == 'P' else 'e'
        module['courses'].add(course_map[row['verwenbar']])
    return modules

course_map = {
    'BWL (B.Sc.)':"bwl_bachelor",
    'BWL (M.Sc.)':"bwl_master",
    'VWL (B.Sc.)':"vwl_bachelor",
    'VWL (M.Sc.)':"vwl_master",
    'WiChem (B.Sc.)':"wichem_bachelor",
    'WiChem (M.Sc.)':"wichem_master",
}

def merge_groups(groups):
    seen = set()
    result = []
    for group in groups:
        groupkey = str(group['sessions']) # meh
        if groupkey in seen:
            continue
        result.append(group)
        seen.add(groupkey)
    return result


def extract_groups(data):
    groups = []
    for i, row in data.iterrows():
        assert isinstance(row['Slot2'], (int, str))
        if row['Slot2']:
            slots = [row['Slot'], row['Slot2']]
            sessions = [{'slot': s, 'rhythm': row['Rhythmus']} for s in slots]
            if row['Rhythmus'] in (1,2) and row['Anzahl SWS'] == 3:
                sessions[0]['rhythm'] = 0
                sessions[0]['duration'] = 2
                sessions[1]['duration'] = 2
            else:
                sessions[0]['duration'] = row['Anzahl SWS'] // 2
                sessions[1]['duration'] = row['Anzahl SWS'] - sessions[0]['duration']
            # both sessions belong to the same group
            group = {'title': row['Veranstaltungstitel'], 'sessions': sessions}
            groups.append(group)
        elif not row['Slot2']:
            slots = [row['Slot']] + row['Alternatives']
            sessions = [{'slot': s, 'rhythm': row['Rhythmus'], 'duration': row['Anzahl SWS']} for s in slots]
            for session  in sessions:
                # if rhythm is not 0 then each sessions has double the length of the unit
                if row['Rhythmus'] in (1,2):
                    session['duration'] = session['duration']*2
                # each session represents a group
                group = {'title': row['Veranstaltungstitel'], 'sessions': [session]}
                groups.append(group)
        else:
            import pdb; pdb.set_trace()
    return merge_groups(groups)


def extract_units(data):
    units = []
    for _, rows in data:
        groups = extract_groups(rows[['Veranstaltungstitel', 'Anzahl SWS', 'Slot', 'Slot2', 'Alternatives', 'Rhythmus']])
        assert len(groups) > 0
        title, duration = rows.iloc[0][['Veranstaltungstitel', 'Anzahl SWS']]
        ntitle = rows.iloc[0]['N:Title']
        unit = {'duration': duration, 'groups': groups, 'title':title, 'id':ntitle}
        units.append(unit)
    # XXX check that title is the same for all rows
    return units, {u['id']: i for i,u in enumerate(units, 1)}


def extract_sessions(units):
    sessions = []
    for u in units:
        for g in u['groups']:
            start = len(sessions)
            for s in g['sessions']:
                sessions.append(s)
            g['sessions'] = list(range(start, len(sessions)))
    return sessions


def extract_mapping(modules, units, map, table):
    mapping = []
    for m in modules.keys():
        module_courses = table[table['Modul'] == m].drop_duplicates(['Modul', 'Kursnummer'])
        for i, row in module_courses.iterrows():
            course = row['Kursnummer']
            unit = map[row['N:Title']]
            for name in ['bwl', 'vwl', 'wichem']:
                major_name = name + '_' +row['Grad'].lower()

                typ = row[name+'_priority']
                if typ == '0':
                    continue
                typ = 'm' if typ == 'P' else 'e'

                semesters = [row[name+'_semester'], row[name+'_alt_semester']]
                for s in semesters:
                    if s == 0:
                        continue
                    mapping.append((m, course, major_name, typ, s, unit))
    return mapping


FORMATS={
    'sql': {
        'SEPARATOR': ',\n' + ' ' * 8,
        'MODULE': '("{name}", "{frequency}", datetime("now"), datetime("now"))',
        'SESSION': '({id}, {group_id}, "{slot}", 0, 2, datetime("now"), datetime("now"))',
        'UNIT': '({id}, "{title}", {duration}, (SELECT id FROM departments WHERE name LIKE "wiwi"), datetime("now"), datetime("now"))',
        'GROUP': '({id}, {unit_id}, "{title}", datetime("now"), datetime("now"))',
        'MODULES_FOCUS_AREAS': 'INSERT INTO "modules_focus_areas" (module_id, focus_area_id) VALUES ((SELECT id FROM modules WHERE name LIKE "{module}"), {focus_area_id});',
        'COURSES_MODULES_UNITS': 'INSERT INTO "courses_modules_units" (course_id, module_id, semester, unit_id, type) VALUES ((SELECT id FROM courses WHERE name LIKE "{course}"), (SELECT id FROM modules WHERE name LIKE "{module}"), {semester}, {unit}, "{type}");',
        'COURSES_MODULES': '((SELECT id FROM courses WHERE name LIKE "{course}"), (SELECT id FROM modules WHERE name LIKE "{module}"), "{type}")',
    }
}


def gen_sql(mods, units, mapping, machine_name, table):
    f = FORMATS['sql']

    formatted_units = []
    formatted_groups = []
    formatted_sessions = []
    formatted_modules_focus_areas = []
    formatted_courses_modules = []
    formatted_courses_modules_units = []
    #
    formatted_modules = f['SEPARATOR'].join(f['MODULE'].format(**module) for
            name, module in mods.items())
    #
    for name, m in mods.items():
        for c in m['courses']:
            formatted_courses_modules.append(f['COURSES_MODULES'].format(course=c, module=name, type=m['type']))
    #
    formatted_modules_focus_areas = (f['MODULES_FOCUS_AREAS'].format(module=name, focus_area_id=i) for
            name in mods for i in range(1, 15))
    #
    for u_id, unit in enumerate(units, 1):
        formatted_units.append(f['UNIT'].format(id=u_id,
            duration=unit['duration'], title=unit['title']))
        for group in unit['groups']:
            group_id = len(formatted_groups) + 1
            formatted_group = f['GROUP'].format(id=group_id, unit_id=u_id,
                    title=group['title'])
            formatted_groups.append(formatted_group)
            for i in group['sessions']:
                session_id = len(formatted_sessions)+1
                formatted_sessions.append(f['SESSION'].format(group_id=group_id, id=session_id, **i))
    #
    formatted_courses_modules_units = \
        (f['COURSES_MODULES_UNITS'].format(course=major, module=module,
            semester=semester, type=typ, unit=unit_id) for (module, klass,
                major, typ, semester, unit_id) in mapping)
    formatted_courses_modules_units = '\n'.join(formatted_courses_modules_units)
    #
    formatted_groups = f['SEPARATOR'].join(formatted_groups)
    formatted_sessions = f['SEPARATOR'].join(formatted_sessions)
    formatted_units = f['SEPARATOR'].join(formatted_units)

    formatted_courses_modules = f['SEPARATOR'].join(formatted_courses_modules)

    formatted_modules_focus_areas = '\n'.join(formatted_modules_focus_areas)

    return SQL.format(generated=datetime.now(), seed=seed,
            modules=formatted_modules, sessions=formatted_sessions,
            units=formatted_units, groups=formatted_groups,
            modules_focus_areas=formatted_modules_focus_areas,
            courses_modules=formatted_courses_modules,
            courses_modules_units=formatted_courses_modules_units)


def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('input', help="path to input file",
                        type=argparse.FileType('r'))
    parser.add_argument('output', help="path to output file",
                        type=argparse.FileType('w'))

    args = parser.parse_args()

    rcprint("Loading input from " + args.input.name)

    table = pandas.read_excel(args.input.name, 0, verbose=True, skiprows=2, encoding='utf8')

    # rename columns
    col_names = list(reversed(['Slot', 'Slot2', 'Valt'] + ['Alternative']*7 + ['Schwerpunkt', 'Schwerpunkt', 'Rhythmus']))
    new_names = {col: col_names.pop() if col.startswith('Unnamed') else col for col in table.columns}
    new_names.update({
                "Priorität":'bwl_priority',
                "MS": 'bwl_semester',
                "WMS": 'bwl_alt_semester',
                # vwl
                "Priorität.1": 'vwl_priority',
                "MS.1": 'vwl_semester',
                "WMS.1": 'vwl_alt_semester',
                # wichem
                "Priorität.2": 'wichem_priority',
                "MS.2": 'wichem_semester',
                "WMS.2": 'wichem_alt_semester',
            })
    table = table.rename(columns=new_names)
    rcprint("Renamed column")
    # cleanup
    table['Schwerpunkt'] = table['Schwerpunkt'].fillna(0).applymap(int)
    table['Rhythmus'] = table['Rhythmus'].fillna(0)
    table['Veranstaltungstitel'] = table['Veranstaltungstitel'].fillna('Title Missing!')

    # propagate module information before dropping rows
    table['Modul'] = table['Modul'].fillna(method='ffill')

    # drop block seminars
    table = table[table.Rhythmus < 3]
    table['Alternative'] = table['Alternative'].replace(0, numpy.nan).replace(3, numpy.nan)

    # drop column
    try:
        del table['Stand']
    except KeyError:
        pass

    # downcase slot names
    # lower() turns '' into NaN which are dropped bellow
    table['Alternative'] = table['Alternative'].fillna('').applymap(lambda x: str(x).lower())
    table['Slot'] = table['Slot'].str.lower()
    table['Slot2'] = table['Slot2'].fillna('').str.lower()

    # drop 'empty' rows -> no slot information
    table = table[(table.Slot.str.startswith('noch') == False) & (table.Slot.isnull() == False)]
    rcprint("dropped invalid rows")

    table[['Slot', 'Slot2']] = table[['Slot', 'Slot2']].fillna('').applymap(
                                    lambda x: x[:2] if isinstance(x, str) else x)
    table['Alternatives'] = [[slot for slot in row if slot != ''] for row in table['Alternative'].values]
    rcprint("Cleaned up timeslots")

    table['Schwerpunkte'] = pandas.Series([[s for s in row if s > 0] for row in table['Schwerpunkt'].values], index=table.index)
    rcprint("Cleaned up focus areas")

    # Fill remaining empty cells with values above in the same column
    table = table.fillna(method='ffill')
    rcprint("Filled empty cells")
    table[['bwl_semester', 'bwl_alt_semester',
        'vwl_semester', 'vwl_alt_semester',
        'wichem_semester', 'wichem_alt_semester']] = table[['bwl_semester', 'bwl_alt_semester',
        'vwl_semester', 'vwl_alt_semester',
        'wichem_semester', 'wichem_alt_semester']].applymap(lambda x: int(x[0]) if isinstance(x, str) else int(x))

    # data transformations
    table['Anzahl SWS'] = table['Anzahl SWS'].map(lambda x: int(x.split()[0]))
    table['Valt'] = table['Valt'].map(bool)
    table['Rhythmus'] = table['Rhythmus'].map(int)
    table['Kursnummer'] = table['Kursnummer'].map(lambda x: int(x.split()[-1]))

    table['N:Title'] = table.apply(normalized_title, axis=1)
    rcprint("Normalized input")
    #
    modules = extract_modules(table[['Modul', 'Modultyp', 'Angebot', 'verwenbar']].drop_duplicates())
    rcprint("Extracted module information")
    #
    units, map = extract_units(table.groupby('N:Title', axis=0))
    rcprint("Extracted unit information")
    #
    mapping = extract_mapping(modules, units, map, table)
    rcprint("Extracted mapping information")
    #
    machine_name = os.path.split(args.output.name)[-1].split('.')[0]

    rcprint("Generating sql file")
    print(gen_sql(modules, units, mapping, machine_name, table), file=args.output)
    #
    print()
    cprint("Done: Output written to " + args.output.name, 'green')


if __name__ == '__main__':
    main(sys.argv)
