
SHELL := /bin/bash

BUILD := build

PREFIX := pdfimages-has-a-bad-ui-and-that-makes-me-sad

ROSTER := $(wildcard *.pdf)

CSV := $(ROSTER:%=$(BUILD)/%/csv)
PDF := $(ROSTER:%=$(BUILD)/%/pdf)
PPM := $(ROSTER:%=$(BUILD)/%/ppm)
TXT := $(ROSTER:%=$(BUILD)/%/txt)

RECURSE := $(ROSTER:%=$(BUILD)/%/recurse)

NETID := $(ROSTER:%=$(BUILD)/%/netid)

PNG = $(foreach x,$(NETID),$(wildcard $(x)/*.png))

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
	rm -f '$@'
	mkdir -p '$(dir $@)'
	ln -r -s '$<' '$@'

$(BUILD)/%.pdf/ppm: %.pdf
	rm -rf '$@'
	mkdir -p '$@'
	pdfimages '$<' '$@/$(PREFIX)'
	cd '$@' && rename -v 's/$(PREFIX)-(...)\.ppm/$$1\.ppm/' *.ppm

$(BUILD)/%.pdf/txt: %.pdf
	mkdir -p $(dir $@)
	pdftotext '$<' '$@'

$(BUILD)/%.pdf/csv: $(BUILD)/%.pdf/txt
	python txt-to-csv.py --txt '$<' --csv '$@' --debug 1

$(BUILD)/%.pdf/recurse: build.mk always
	cd $(dir $@) && $(MAKE) -f ../../$<
	touch $@

.netid: always
	rm -rf $(BUILD)/netid
	mkdir -p $(BUILD)/netid
	for i in $(PNG); \
	do \
		ln -r -s -t $(BUILD)/netid "$$i"; \
	done

always: ;

