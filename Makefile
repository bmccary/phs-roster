
SHELL := /bin/bash

include options.mk
-include local.mk

ROSTER := $(wildcard *.pdf)

CSV := $(ROSTER:%=$(BUILD)/%/csv)
PDF := $(ROSTER:%=$(BUILD)/%/pdf)
PPM := $(ROSTER:%=$(BUILD)/%/ppm)
TXT := $(ROSTER:%=$(BUILD)/%/txt)


CSV0 := $(wildcard *.csv)

ifeq ($(strip $(MAKE_PDF)),)
TEX1 :=
PDF1 :=
else
TEX1 := $(CSV0:%.csv=$(BUILD)/%.tex)
PDF1 := $(TEX1:%.tex=%.pdf)
endif

ifeq ($(strip $(MAKE_XLSX)),)
XLSX1 :=
else
XLSX1 := $(CSV0:%.csv=$(BUILD)/%.xlsx)
endif

RECURSE := $(ROSTER:%=$(BUILD)/%/recurse)

NETID := $(ROSTER:%=$(BUILD)/%/netid)

PNG = $(foreach x,$(NETID),$(wildcard $(x)/*.png))

ALL := .csv .netid .pdf .ppm .tex1 .pdf1 .txt .recurse .xlsx

all: $(ALL)

clean:
	rm -rf $(BUILD) $(ALL)

.csv: $(CSV) $(BUILD)/csv
	touch $@

$(BUILD)/csv: $(CSV)
	$(PYTHON) merge-csv.py --csv1 $@ --csv0 $+

.pdf: $(PDF)
	touch $@

.ppm: $(PPM)
	touch $@

.txt: $(TXT)
	touch $@

.recurse: $(RECURSE)
	touch $@

.xlsx: $(XLSX1)
	touch $@

.tex1: $(TEX1)
	touch $@

.pdf1: $(PDF1)
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

$(BUILD)/%.pdf/recurse: build.mk .csv .pdf .ppm .txt
	cd $(dir $@) && $(MAKE) -f $(realpath $<)
	touch $@

.netid: .recurse
	rm -rf $(BUILD)/netid
	mkdir -p $(BUILD)/netid
	cd $(BUILD)/netid; \
	for i in $(PNG); \
	do \
		d=$$(echo $$i | perl -p -e 's/$(BUILD)\/(.+\.pdf)\/netid\/(.+)\.png/$$2\/$$1\.png/g'); \
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
				if [[ -n "$(NOTIFY_MULTIPLE)" ]]; \
				then \
					echo "netid '$$i' appears in more than one roster (may be OK):"; \
					for k in $$(ls -1 $$i); do echo -n "    "; readlink $$i/$$k; done; \
				fi; \
				;; \
		esac; \
		ln -s $$i/$$(ls -1 $$i | head -n 1) $$i.png; \
	done
	touch $@

$(BUILD)/%.xlsx: %.csv .csv .netid 
	$(PYTHON) csv-to-xlsx.py --csv $(BUILD)/csv --netid $(BUILD)/netid --csv0 $< --xlsx1 $@ --width $(WORKSHEET_IMAGE_COL_WIDTH) --height $(WORKSHEET_IMAGE_ROW_HEIGHT) $(FLIP)

local.sty:
	( \
		echo "\\def\\imheight{50mm}"; \
	) > $@

$(BUILD)/%.tex: %.csv local.sty .netid
	$(PYTHON) csv-to-tex.py --csv $(BUILD)/csv --netid $(BUILD)/netid --csv0 $< --tex1 $@ --sty $(basename local.sty) $(FLIP) --orientation $(ORIENTATION)

$(BUILD)/%.pdf: $(BUILD)/%.tex local.sty .netid
	pdflatex -output-directory $(dir $<) $< 
	pdflatex -output-directory $(dir $<) $< 
	rm -f $(basename $<).{aux,log,out}

always: ;

