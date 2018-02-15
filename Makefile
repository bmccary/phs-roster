
SHELL := /bin/bash

include options.mk

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
	cd '$(dir $@)' && ln -s ../../'$<' '$(notdir $@)'

$(BUILD)/%.pdf/ppm: %.pdf
	rm -rf '$@'
	mkdir -p '$@'
	pdfimages '$<' '$@/$(PREFIX)'
	cd $@ && \
	for i in $(PREFIX)-*.ppm; \
	do \
		mv $$i $$(echo $$i | sed s/$(PREFIX)-//g); \
	done

$(BUILD)/%.pdf/txt: %.pdf
	mkdir -p $(dir $@)
	pdftotext '$<' '$@'

$(BUILD)/%.pdf/csv: $(BUILD)/%.pdf/txt
	$(PYTHON) txt-to-csv.py --txt '$<' --csv '$@' --debug 1

$(BUILD)/%.pdf/recurse: build.mk .csv .pdf .ppm .txt always
	cd $(dir $@) && $(MAKE) -f $(realpath $<)
	touch $@

.netid: always
	rm -rf $(BUILD)/netid
	mkdir -p $(BUILD)/netid
	cd $(BUILD)/netid; \
	for i in $(PNG); \
	do \
		d=$$(echo $$i | sed -r 's/$(BUILD)\/(.+\.pdf)\/netid\/(.+)\.png/\2\/\1\.png/g'); \
		mkdir -p $$(dirname $$d); \
		ln -s ../../../$$i $$d; \
	done
	cd $(BUILD)/netid; \
	for i in *; \
	do \
		case $$(ls -1 $$i | wc -l) in \
			0) \
				echo "No files in $$i"; \
				exit 1; \
				;; \
			1) \
				;; \
			*) \
				echo "netid '$$i' appears in more than one roster (may be OK):"; \
				for k in $$(ls -1 $$i); do echo -n "    "; readlink $$i/$$k; done; \
				;; \
		esac; \
		ln -s $$i/$$(ls -1 $$i | head -n 1) $$i.png; \
	done

always: ;

