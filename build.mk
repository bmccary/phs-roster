
SHELL := /bin/bash

THISMK := $(lastword $(MAKEFILE_LIST))

include $(dir $(THISMK))/options.mk

NETID := $(shell cat csv | tail -n +2 | cut -f 2 -d ,)

PNG := $(NETID:%=netid/%.png)

ALL := .netid .netid-r $(PNG)

all: $(ALL)

.netid: csv
	rm -rf netid
	$(PDF_VIEWER) pdf &
	$(MAKE) -f $(THISMK) .netid-r
	touch $@

.netid-r: $(PNG)
	touch $@

netid-to-index = $(shell grep $(1) $(2) | cut -f 1 -d ,)

netid/%.png: csv
	rm -f '$@'
	mkdir -p $(dir $@)
	$(IMAGE_VIEWER) 'ppm/$(call netid-to-index,$*,$<).ppm' & echo "$$!" > '$*.pid'
	if $(call YESNO,$(notdir $*)); then convert 'ppm/$(call netid-to-index,$*,$<).ppm' '$@'; else exit 1; fi
	kill "$$(< $*.pid)" || true
	rm -f '$*.pid'

