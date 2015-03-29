modelgenerator=bin/modelgenerator.jar
MODEL_GENERATOR_VERSION=0.4.0

# path to put the virtualenv in case we create a new one
LOCAL_VIRTUAL_ENV=slottool_env

VENV=$(LOCAL_VIRTUAL_ENV)
ifdef VIRTUAL_ENV
	VENV=$(VIRTUAL_ENV)
endif

bin/wiwi.py bin/phil-fak.py: requirements.inst

HASHSEED:=$(shell awk 'BEGIN{srand();printf("%d", 4294967295*rand())}')

data_file=raw/phil-fak.csv
data.sql: bin/phil-fak.py $(data_file)
	PYTHONHASHSEED=$(HASHSEED) $(VENV)/bin/python3 $^ $@

wiwi_data_file=raw/wiwi.xlsx
wiwi_data.sql: bin/wiwi.py $(wiwi_data_file)
	PYTHONHASHSEED=$(HASHSEED) $(VENV)/bin/python3 $^ $@

random.sql: bin/random_timetable.py
ifndef RANDOMSEED
	$(VENV)/bin/python $^ --output=$@
else
	$(VENV)/bin/python $^ --output=$@ --seed=$(RANDOMSEED)
endif


DATABASES=data.sqlite3 wiwi_data.sqlite3 random.sqlite3
$(DATABASES): %.sqlite3: %.sql schema.sql
	rm -f $@
	sqlite3 $@ < $<

$(modelgenerator):
	curl http://nightly.cobra.cs.uni-duesseldorf.de/slottool/model-generator-standalone-$(MODEL_GENERATOR_VERSION).jar -z $(modelgenerator) -o $(modelgenerator) --silent --location

data.mch: data.sqlite3 $(modelgenerator)
	java -jar $(modelgenerator) --database=$< --format=b --faculty=philfak --output=$@

data.pl: data.sqlite3 $(modelgenerator)
	java -jar $(modelgenerator) --database=$< --format=prolog --faculty=philfak --output=$@

wiwi_data.mch: wiwi_data.sqlite3 $(modelgenerator)
	java -jar $(modelgenerator) --database=$< --format=b --faculty=wiwi --output=$@

wiwi_data.pl: wiwi_data.sqlite3 $(modelgenerator)
	java -jar $(modelgenerator) --database=$< --format=prolog --faculty=wiwi --output=$@

$(VIRTUAL_ENV):

$(LOCAL_VIRTUAL_ENV):
	if [ ! -d "$(VENV)" ]; then virtualenv -p `which python3` $(VENV); fi

requirements.inst: requirements.txt $(VENV)
	$(VENV)/bin/pip install -r requirements.txt
	touch requirements.inst

clean:
	rm -f data.sql
	rm -f data.sqlite3
	rm -f wiwi_data.sql
	rm -f wiwi_data.sqlite3
	rm -f random.sql
	rm -f random.sqlite3
	rm -f requirements.inst
	rm -f *.mch
	rm -f *.prob
	rm -f *.pl

very_clean: clean
	rm -rf $(LOCAL_VIRTUAL_ENV)
	rm -f $(modelgenerator)

# distribution rules
dist-setup:
	mkdir -p dist

version: data.sqlite3
	$(eval VERSION:=$(shell sqlite3 $^ "select value from info where key='schema_version';"))

philfak-dist: data.sqlite3 | dist-setup
	cp $^ dist/data.sqlite3

wiwi-dist: wiwi_data.sqlite3 | dist-setup
	cp $^ dist/data.sqlite3

flavor=philfak
dist: $(join $(flavor),-dist)

.PHONY: clean very_clean dist-setup philfak-dist wiwi-dist dist $(modelgenerator) version
.INTERMEDIATE: data.sql wiwi_data.sql data.sqlite3 wiwi_data.sqlite3
