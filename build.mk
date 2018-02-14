
SHELL := /bin/bash

NETID := $(shell cat csv | tail -n +2 | cut -f 2 -d ,)

PNG := $(NETID:%=netid/%.png)

DIALOG = dialog --title 'Feed me, human!' --yesno 'Is it $(1)?' 8 60
ZENITY = zenity --question --text='Is it $(1)?'
PROMPT = $(ZENITY)

ALL := .netid .netid-r $(PNG)

all: $(ALL)

.netid: csv
	rm -rf netid
	evince pdf &
	$(MAKE) -f $(lastword $(MAKEFILE_LIST)) .netid-r
	touch $@

.netid-r: $(PNG)
	touch $@

netid-to-index = $(shell grep $(1) $(2) | cut -f 1 -d ,)

netid/%.png: csv
	rm -f '$@'
	mkdir -p $(dir $@)
	display 'ppm/$(call netid-to-index,$*,$<).ppm' & echo "$$!" > '$*.pid'
	if $(call PROMPT,$(notdir $*)); then convert 'ppm/$(call netid-to-index,$*,$<).ppm' '$@'; else exit 1; fi
	kill "$$(< $*.pid)" || true
	rm -f '$*.pid'

