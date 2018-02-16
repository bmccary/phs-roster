
SHELL := /bin/bash

THISMK := $(lastword $(MAKEFILE_LIST))

include $(dir $(THISMK))/options.mk
-include $(dir $(THISMK))/local.mk

NETID := $(shell cat csv | tail -n +2 | cut -f 2 -d ,)

PNG := $(NETID:%=netid/%.png)
STAMP := $(PNG:netid/%.png=stamp/%.png)

ALL := .netid .netid-r .stamp .stamp-r $(PNG) $(STAMP) drag-and-drop.xlsx

all: $(ALL)

.netid: csv
	rm -rf netid
	if [[ "$(YESNO)" != "YESNO_TRUE" ]]; then $(PDF_VIEWER) pdf & fi
	$(MAKE) -f $(THISMK) $@-r
	touch $@

.netid-r: $(PNG)
	touch $@

netid-to-index = $(shell grep $(1) $(2) | cut -f 1 -d ,)

netid/%.png: csv
	rm -f '$@'
	mkdir -p $(dir $@)
	if [[ "$(YESNO)" != "YESNO_TRUE" ]]; then $(IMAGE_VIEWER) 'ppm/$(call netid-to-index,$*,$<).ppm' & echo "$$!" > '$*.pid'; fi
	if $(call $(YESNO),$(notdir $*)); then convert -resize x$(IMAGE_CONVERT_HEIGHT) 'ppm/$(call netid-to-index,$*,$<).ppm' '$@'; else exit 1; fi
	kill "$$(< $*.pid)" || true
	rm -f '$*.pid'

.stamp: .netid
	rm -rf stamp
	$(MAKE) -f $(THISMK) $@-r
	touch $@

.stamp-r: $(STAMP)
	touch $@

stamp/%.png: netid/%.png
	mkdir -p $(dir $@)
	convert -undercolor White -gravity South -pointsize 30 -annotate 0 '$(basename $(notdir $@))' $< $@

drag-and-drop.xlsx: .stamp
	$(PYTHON) $(dir $(THISMK))/drag-and-drop-xlsx.py --xlsx1 $@ --netid stamp --imwidth $(XLSX_IMAGE_COL_WIDTH) --imheight $(XLSX_IMAGE_ROW_HEIGHT) --width $(XLSX_DRAG_AND_DROP_IMAGES_PER_ROW)

