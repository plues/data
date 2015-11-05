# PlüS Data

This repository is part of the [PlüS Project](https://github.com/plues) and
contains:

* Timetabling data provided by the participating faculties faculties of
  Humanities and Economics at the [Heinrich-Heine University Düsseldorf](http://hhu.de).
* Tools to generate a SQLite database from the raw data and to generate
  different target formats from the database using
  [model-generator](https://github.com/plues/model-generator).

## Generating data

To generate the sql data representations or an already seeded SQLite database
use the provided makefile targets.

Call `make data.sql` or `make data.sqlite3` to generate the corresponding files
with the data of the faculty of humanities.

Call `make wiwi_data.sql` or `make wiwi_data.sqlite3` to generate the
data for the facutlty of economics.

**Note**: The tools used to generate the `.sql` files are implemented in Python
and are thus subject to Python's hash randomization which affects the order of
the elements in the generated database. The used seed for the randomization is
stored in the genrated database.

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
* sqlite3
* java (for the model-generator)

For further dependencies (installed automatically) see [requirements.txt](requirements.txt).


## LICENSE

### Timetabling Data

All timetabling data as provided in the `raw/` directory is available unter the terms of the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License](http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode).

[![Creative Commons License](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

### Source code

The source code distributed in this repository to process and transform the raw data is distributed under the terms of the [ISC License](LICENSE).
