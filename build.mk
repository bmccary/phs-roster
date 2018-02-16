
SHELL := /bin/bash

THISMK := $(lastword $(MAKEFILE_LIST))

include $(dir $(THISMK))/options.mk
-include $(dir $(THISMK))/local.mk

NETID := $(shell cat csv | tail -n +2 | cut -f 2 -d ,)

PNG := $(NETID:%=netid/%.png)

ifeq ($(strip $(MAKE_DRAG_AND_DROP)),)
STAMP :=
DRAG_AND_DROP :=
else
STAMP := $(PNG:netid/%.png=stamp/%.png)
DRAG_AND_DROP := .stamp drag-and-drop.xlsx
endif

ALL := .netid $(PNG) $(DRAG_AND_DROP)

all: $(ALL)

.netid: csv
	rm -rf netid
	if [[ "$(YESNO)" != "YESNO_TRUE" ]]; then $(PDF_VIEWER) pdf & fi
	$(MAKE) -f $(THISMK) $@-r
	touch $@

.netid-r: $(PNG)
	touch $@

netid-to-i = $(shell grep $(1) $(2) | cut -f $(3) -d ,)

netid/%.png: csv
	rm -f '$@'
	mkdir -p $(dir $@)
	if [[ "$(YESNO)" != "YESNO_TRUE" ]]; then $(IMAGE_VIEWER) 'ppm/$(call netid-to-i,$*,$<,1).ppm' & echo "$$!" > '$*.pid'; fi
	if $(call $(YESNO),$(notdir $*)); then convert -resize x$(IMAGE_CONVERT_HEIGHT) 'ppm/$(call netid-to-i,$*,$<,1).ppm' '$@'; else exit 1; fi
	if [[ "$(YESNO)" != "YESNO_TRUE" ]]; then kill "$$(< $*.pid)" || true; fi
	rm -f '$*.pid'

.stamp: .netid
	rm -rf stamp
	$(MAKE) -f $(THISMK) $@-r
	touch $@

.stamp-r: $(STAMP)
	touch $@

stamp/%.png: netid/%.png
	mkdir -p $(dir $@)
	convert -undercolor White -gravity South -pointsize 20 -annotate 0 "$(call netid-to-i,$*,csv,3), $(call netid-to-i,$*,csv,4)\n$*" $< $@

drag-and-drop.xlsx: .stamp 
	$(PYTHON) $(dir $(THISMK))/drag-and-drop-xlsx.py --xlsx1 $@ --netid stamp --imwidth $(XLSX_IMAGE_COL_WIDTH) --imheight $(XLSX_IMAGE_ROW_HEIGHT) --width $(XLSX_DRAG_AND_DROP_IMAGES_PER_ROW)

