MODEL_GENERATOR_VERSION=2.0.0-SNAPSHOT
modelgenerator=bin/modelgenerator-$(MODEL_GENERATOR_VERSION).jar

MINCER_VERSION=0.1.0-SNAPSHOT
mincer=bin/mincer-$(MINCER_VERSION).jar

# Available flavors for data
FLAVORS := philfak wiwi
# Default flavor
flavor=philfak

# Available actions
ACTIONS := data.mch data.sqlite3
TARGETS :=$(foreach i,$(FLAVORS),$(foreach j,$(ACTIONS),$(join $i,-$j)))

# Default targets
dist: $(join $(flavor),-dist)
data.mch: $(join $(flavor),-data.mch)
	cp $< $@
data.sqlite3: $(join $(flavor),-data.sqlite3)
	cp $< $@

# Files produced by $(flavor)
DATABASES:=$(foreach f,$(FLAVORS),$(join $(f),-data.sqlite3))
MACHINES:=$(foreach f,$(FLAVORS),$(join $(f),-data.mch))

# flavored dist action
DIST:=$(foreach f,$(FLAVORS),$(join $(f),-dist))


# FLAVOR files
# philfak flavor files
philfak-tree=raw/philfak/Modulbaum.xml
philfak-data=raw/philfak/Moduldaten.xml

# wiwi flavor files
wiwi-tree=
wiwi-data=

$(DATABASES): %-data.sqlite3: $(mincer) $($(flavor)-tree) $($(flavor)-data)
	java -jar $(mincer) --output=$@ --module-tree=$($(flavor)-tree) --module-data=$($(flavor)-data)

$(MACHINES): %.mch: %.sqlite3 | $(modelgenerator)
	java -jar $(modelgenerator) --database=$< --output=$@

# distribution rules
dist-setup:
	mkdir -p dist

$(DIST): %-dist: %-data.sqlite3 | dist-setup
	cp $^ dist/data.sqlite3

bin/:
	mkdir -p bin/

$(modelgenerator): bin/
	curl http://www3.hhu.de/stups/downloads/plues/model-generator/model-generator-standalone-$(MODEL_GENERATOR_VERSION).jar -z $(modelgenerator) -o $(modelgenerator) --silent --location

$(mincer): bin/
	curl http://nightly.cobra.cs.uni-duesseldorf.de/slottool/mincer/mincer-$(MINCER_VERSION)-standalone.jar -z $(mincer) -o $(mincer) --silent --location

clean:
	rm -rf dist/
	rm -f $(TARGETS) $(ACTIONS)
	rm -f *.prob

very_clean: clean
	rm -f $(modelgenerator)
	rm -f $(mincer)

.PHONY: clean very_clean dist-setup $(ACTIONS) $(FLAVORS)
.INTERMEDIATE: $(TARGETS)
