
SHELL := /bin/bash

BUILD := build

PREFIX := i

ROSTER := $(wildcard *.pdf)

CSV := $(ROSTER:%=$(BUILD)/%/csv)
PDF := $(ROSTER:%=$(BUILD)/%/pdf)
PPM := $(ROSTER:%=$(BUILD)/%/ppm)
TXT := $(ROSTER:%=$(BUILD)/%/txt)

RECURSE := $(ROSTER:%=$(BUILD)/%/recurse)

NETID := $(ROSTER:%=$(BUILD)/%/netid)

PNG = $(shell find $(NETID) -name '*.png')

ALL := .csv .pdf .ppm .txt .recurse .netid

all: $(ALL)

clean:
	rm -rf $(BUILD) $(ALL)

.csv: $(CSV)
	touch $@

.pdf: $(PDF)
	touch $@

.ppm: $(PPM)
	touch $@

.txt: $(TXT)
	touch $@

.recurse: $(RECURSE)
	touch $@

$(BUILD)/%.pdf/pdf: %.pdf
	rm -f $@
	mkdir -p $(dir $@)
	cd $(dir $@) && ln -s '../../$<' pdf

$(BUILD)/%.pdf/ppm: %.pdf
	rm -rf $@
	mkdir -p $@
	pdfimages '$<' '$@/$(PREFIX)'

$(BUILD)/%.pdf/txt: %.pdf
	mkdir -p $(dir $@)
	pdftotext '$<' '$@'

$(BUILD)/%.pdf/csv: $(BUILD)/%.pdf/txt
	python txt-to-csv.py --txt '$<' --csv '$@' --debug 1

$(BUILD)/%.pdf/recurse: build.mk always
	cd $(dir $@) && $(MAKE) PREFIX=$(PREFIX) -f ../../$<
	touch $@

.netid: always
	$(MAKE) .netid-r

.netid-r: always
	rm -rf $(BUILD)/netid
	mkdir -p $(BUILD)/netid
	for i in $(PNG); \
	do \
		ln -r -s -t $(BUILD)/netid $$i; \
	done

always: ;

