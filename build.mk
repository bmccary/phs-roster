
SHELL := /bin/bash

NETID0 := $(shell cat csv | tail -n +2 | cut -f 2 -d ,)

NETID := $(NETID0:%=netid/%.png)

DIALOG := dialog --title "Message"  --yesno "Are you having\ fun?" 6 25

ALL := .netid .netid-r $(NETID)

all: $(ALL)

.netid: csv
	rm -rf netid
	evince pdf &
	$(MAKE) -f $(lastword $(MAKEFILE_LIST)) .netid-r
	touch $@

.netid-r: $(NETID)
	touch $@

netid/%.png: csv
	rm -f '$@'
	mkdir -p $(dir $@)
	display 'ppm/$(PREFIX)-$(shell grep $* $< | cut -f 1 -d ,).ppm' & echo "$$!" > "$*.pid"
	if zenity --question --text='Is it $(notdir $*)?'; then convert 'ppm/$(PREFIX)-$(shell grep $* $< | cut -f 1 -d ,).ppm' '$@'; else exit 1; fi
	#if dialog --title 'Feed me, human!' --yesno 'Is it $(notdir $*)?' 10 60; then convert 'ppm/$(PREFIX)-$(shell grep $* $< | cut -f 1 -d ,).ppm' '$@'; else exit 1; fi
	kill "$$(< $*.pid)" || true
	rm -f "$*.pid"

