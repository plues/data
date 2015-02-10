# Data

This repository contains the tools to generate sql files from raw timetable
input data as provided by the faculties of Humanities and Economics at HHU.

The ```Makefile``` contains additional targets to generate B and prolog
representations of the input-data using
[model-generator](http://gitlab.cobra.cs.uni-duesseldorf.de/slottool/model-generator).

## Generating data

To generate the sql data representations or an already seeded SQLite database
use the provided makefile targets.

Call ```make data.sql``` or ```make data.sqlite3``` for the data of the
Humanities.

Call ```make wiwi_data.sql``` or ```make wiwi_data.sqlite3``` to generate the
data for the facutlty of Economics.

## Dependencies

* python3
* virtualenv
* PyYAML
* pandas
* pytest
* termcolor
* sqlite3
* java (for the model-generator)
