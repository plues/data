# Data

This repository contains the tools to generate sql files from raw timetable
input data as provided by the faculties of Humanities and Economics at HHU.

The `Makefile` contains additional targets to generate B and prolog
representations of the input-data using
[model-generator](http://gitlab.cobra.cs.uni-duesseldorf.de/slottool/model-generator).

## Generating data

To generate the sql data representations or an already seeded SQLite database
use the provided makefile targets.

Call `make data.sql` or `make data.sqlite3` for the data of the
Humanities.

Call `make wiwi_data.sql` or `make wiwi_data.sqlite3` to generate the
data for the facutlty of Economics.

Note: The previous calls use python dictionaries wich are subject to python's
hash randomization which affects the order of the elements in the generated
database. The used seed for the randomization is stored in the genrated database.
To override this behaviour or to re-generate a specific
order in the generated data pass the `HASHSEED` variable to the `Makefile`
targets, e.g.: `make wiwi_data.sqlite3 HASHSEED=x`.

Call `make random.sql` or `make random.sqlite3` to generate a database seed
with random values, the hashseed is printed and stored in the generated file.
The `RANDOMSEED` variable can be passed to the makefile to regenerated a
certain dataset, e.g. `make random.slite3 RANDOMSEED=x`.

## Dependencies

* python3
* virtualenv
* PyYAML
* pandas
* pytest
* termcolor
* sqlite3
* java (for the model-generator)
