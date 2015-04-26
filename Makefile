modelgenerator=bin/modelgenerator.jar
MODEL_GENERATOR_VERSION=0.5.1-SNAPSHOT

# path to put the virtualenv in case we create a new one
LOCAL_VIRTUAL_ENV=slottool_env

VENV=$(LOCAL_VIRTUAL_ENV)
ifdef VIRTUAL_ENV
	VENV=$(VIRTUAL_ENV)
endif

HASHSEED:=$(shell awk 'BEGIN{srand();printf("%d", 4294967295*rand())}')
# export for sub-processes
export PYTHONHASHSEED=$(HASHSEED)

# Available flavors for data
FLAVORS := philfak wiwi random
# Default flavor
flavor=philfak
# Available actions
ACTIONS := dist data.mch data.sql data.sqlite3 data.pl
TARGETS :=$(foreach i,$(FLAVORS),$(foreach j,$(ACTIONS),$(join $i,-$j)))

# Default targets
dist: $(join $(flavor),-dist)
data.mch: $(join $(flavor),-data.mch)
	cp $(MACHINE) $@
data.sql: $(join $(flavor),-data.sql)
	cp $(SQL) $@
data.sqlite3: $(join $(flavor),-data.sqlite3)
	cp $(DATABASE) $@

# Files produced by $(flavor)
DATABASE:=$(join $(flavor),-data.sqlite3)
SQL:=$(join $(flavor),-data.sql)
MACHINE:=$(join $(flavor),-data.mch)
PROLOG:=$(join $(flavor),-data.pl)

bin/wiwi.py bin/phil-fak.py: requirements.inst

data_file=raw/phil-fak.csv
philfak-data.sql: bin/phil-fak.py $(data_file)
	$(VENV)/bin/python3 $^ $@

wiwi_data_file=raw/wiwi.xlsx
wiwi-data.sql: bin/wiwi.py $(wiwi_data_file)
	$(VENV)/bin/python3 $^ $@

random-data.sql: bin/random_timetable.py
ifndef RANDOMSEED
	$(VENV)/bin/python $^ --output=$@
else
	$(VENV)/bin/python $^ --output=$@ --seed=$(RANDOMSEED)
endif


$(DATABASE): %-data.sqlite3: %-data.sql schema.sql
	rm -f $@
	sqlite3 $@ < $<

$(PROLOG): data.sqlite3 $(modelgenerator)
	java -jar $(modelgenerator) --database=$< --format=prolog --output=$@

$(MACHINE): %.mch: %.sqlite3 $(modelgenerator)
	java -jar $(modelgenerator) --database=$< --format=b --output=$@

$(LOCAL_VIRTUAL_ENV):
	if [ ! -d "$(VENV)" ]; then virtualenv -p `which python3` $(VENV); fi

$(modelgenerator):
	curl http://nightly.cobra.cs.uni-duesseldorf.de/slottool/model-generator-standalone-$(MODEL_GENERATOR_VERSION).jar -z $(modelgenerator) -o $(modelgenerator) --silent --location

requirements.inst: requirements.txt $(VENV)
	$(VENV)/bin/pip install -r requirements.txt
	touch requirements.inst

clean:
	rm -f $(TARGETS)
	rm -f data.sqlite3
	rm -f requirements.inst
	rm -f *.prob

very_clean: clean
	rm -rf $(LOCAL_VIRTUAL_ENV)
	rm -f $(modelgenerator)

# distribution rules
dist-setup:
	mkdir -p dist

random-dist philfak-dist wiwi-dist: %-dist: %-data.sqlite3 | dist-setup
	cp $^ dist/data.sqlite3

.PHONY: clean very_clean dist-setup $(ACTIONS) $(modelgenerator)
.INTERMEDIATE: $(TARGETS)
