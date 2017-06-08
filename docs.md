# PlüS Data

This repository contains timetable data for the PlüS Project. 

The data represents the timetable information of the faculties at the [Heinrich-Heine-University Düsseldorf](http://hhu.de) participating in the project.

Each dataset is divided in two parts. One represents the structure of each program, which modules are to be completed and how the modules are organized. The second one describes the structure of the modules, the classes that compose them, and when these classes should be attended in the curriculum. 

## Data Model

Raw data is organized in two XML files, one for the module tree structure and one for the module and class data.

### Module Tree

The module tree data is represented as a tree structure for each course.

The root element is `<ModulBaum>`. Below the root element there are several `<b>` nodes representing each course available in the faculty.

Attributes of the `<b>` provide the details about each course:

- `abschl`: Degree or part of degree represented by this course (bk, ba, ...)
- `stg`: Short name of the course.
- `kzfa`: `H` for major (Hauptfach) or `N` for minor (Nebenfach or Ergänzungsfach), ...
- `pversion`: Curriculum version.
- `name`: name of the course.

Below the `<b>` there is one or none `<minors>` tag describing the possible minor courses a major course is combinable with. These are stated as `<minor>` tags annotated with the following attributes:

- `stg`: Short name of the course.
- `pversion`: Curriculum version. 

Additionally, the course tag can contain one or many `<l>` tags that represent different levels in the structure of the course. Each level is annotated with the following attributes:

- `name`: Name of the level.
- `min`: The minimum number of modules to be chosen for this level.
- `max`: The maximum number of modules to be chosen for this level.
- `TM`:
- `ART`:

The leaves of the module tree are represented by `<m>` nodes representing a module.

Modules are represented by two attributes

- `name`: Name of the module
- `pnr`: If the module is a test, this is the test number.
- `pordnr`: A unique number that globally identifies the module.


### Module Data

Module data is composed of two things. First the information how modules are
structured, i.e. which abstract units compose a module. Second how units are
structured, which groups and sessions compose then as well as the to which
abstract units they are linked.

The information is grouped below the root level `<data>`.  Modules are group
below a `<modules>` node.

#### Modules
Each module is represented by a single `<module>` node and has the following attributes:

- `id`: Globally unique identifier for the module following a specific schema 
 - (TODO: add a ref to the schema)
- `title`: The title of the module.
- `pordnr`: The id of the module in the module tree data.
- `elective-units`: Represents the number of elective units (`type=m` [see
  below]) that have to be attended in order to complete the module's
  requirements.
- `bundled`: A boolean value that is true if all abstract-units of the module have to be graduated in the same semester, otherwise false.

Each module is composed of several abstract units, these are generalized teaching units that are "implemented" by actual units each semester.

#### Abstract Units 

An abstract units is denoted by the node `<abstract-unit>` and the attributes:

- `id`: Global ID.
- `title`: Title of the unit
- `type`: If the unit is mandatory (`"m"`) or elective (`"e"`) in the current module.
- `semester`: The semesters of the curriculum this unit could/should be attended.

#### Units

The second type of node is `<units>` which groups unit information.

Each unit is represented as a `<unit>` node with the following attributes:
- `id`: Unique identifier.
- `title` of the unit.
- `semester`: comma separated list of semesters this unit is offered. Note that this number represents the availability whereas the semester information in the abstract unit represents the recommended semesters according to the curriculum. 

Each `<unit>` can be associated to one or more abstract units. These references are expressed by `<abstract-unit>` child nodes that refer to the `id` of the actual abstract unit defined in a module.
E.g. : `<abstract-unit id="P-Phil-L-BPPANb" />`

#### Groups and sessions

Each `<unit>` can have several `<group>` nodes, each group is a set of events that are considered equivalent, i.e. students have to choose one of the possible groups to complete the unit.
Each `<group>` can have a half-semester attribute. The attribute indicates, that all sessions in the group are only taught for half a semester. The value of the attribute represents in which half of the semester the sessions in the group take place. Possible values are "first" or "second".
Each `<group>` is composed of several sessions, sessions are represented planned teaching events. Each session has the following attributes:

- `day`: Abbreviated day of the week (`"mon"`, `"tue"`, etc.).
- `time`: The time block during the day where the sessions takes place, 
 	- 1 is 8:30 - 10:00
 	- 2 is 10:30 - 12:00
	- etc
- `duration`: The number of hours the sessions takes (default is 2).
- `rhythm`: The rhythm in which the event takes place.
	- 0: Weekly
	- 1: Biweekly on even number calendar weeks.
	- 2: Biweekly on odd number calendar weeks.
	- 3: Unique event or only a small number of repetitions (e.g. Block-Seminar).
- `tentative`: ("true" or "false") Indicates if the day and time are
  provisional, i.e. an unconfirmed event or temporary data.

## Using the data

See [README.md](README.md) for details.
