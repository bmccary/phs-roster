
SHELL := /bin/bash

ROSTER := roster.pdf

NETID = $(shell cat roster.csv | cut -f 2 -d , | tail -n +2)

LINK = $(NETID:%=netid/%.ppm)

PNG = $(LINK:%.ppm=%.png)

VERIFY = $(PNG:%.png=%.verify)

ALL := .pdfimage .link .link-r .png .verify .verify-r roster.txt roster.csv

all: $(ALL)

clean:
	rm -rf image netid $(ALL)

.pdfimage: $(ROSTER) roster.csv
	rm -rf image
	mkdir -p image
	pdfimages '$(ROSTER)' image/i
	touch $@

%.txt: %.pdf
	pdftotext '$<'

%.csv: %.txt
	python txt-to-csv.py --txt '$<' --csv '$@' --debug 1

netid/%.ppm: roster.csv 
	mkdir -p netid
	rm -f '$@'
	cd netid && ln -s '../image/i-$(shell grep $* $< | cut -f 1 -d ,).ppm' '$(notdir $@)'

.link: roster.csv
	rm -rf netid
	$(MAKE) .link-r
	touch $@

.link-r: $(LINK)
	touch $@

.png: $(PNG)
	touch $@

%.png: %.ppm
	convert $< $@

.verify: always 
	evince roster.pdf & echo $$! > .verify.pid
	$(MAKE) .verify-r
	kill $$(< .verify.pid) || true
	rm -f .verify.pid
	touch $@

.verify-r: $(VERIFY)
	touch $@

%.verify: %.png
	display $< & echo $$! > $*.pid
	if zenity --question --text='Is it $(notdir $*)?'; then touch $@; fi
	kill $$(< $*.pid) || true
	rm -f $*.pid

always: ;

