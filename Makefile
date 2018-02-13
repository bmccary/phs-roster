
SHELL := /bin/bash

PDF := $(wildcard *.pdf)
PPM := $(PDF:%.pdf=%.ppm)
TXT := $(PDF:%.pdf=%.txt)
CSV := $(PDF:%.pdf=%.csv)

NETID = $(shell cat $(CSV) | cut -f 2 -d , | grep -v netid)

LINK = $(NETID:%=netid/%.ppm)

PNG = $(LINK:%.ppm=%.png)

VERIFY = $(PNG:%.png=%.verify)

ALL := .csv .link .link-r .png .png-r .ppm .verify .verify-r $(PPM) $(TXT) $(CSV)

all: $(ALL)

clean:
	rm -rf netid $(ALL)

.csv: $(CSV)
	touch $@

.ppm: $(PPM)
	touch $@

%.ppm: %.pdf $(CSV)
	rm -rf $@
	mkdir -p $@
	pdfimages '$<' $@/i

%.txt: %.pdf
	pdftotext '$<'

%.csv: %.txt
	python txt-to-csv.py --txt '$<' --csv '$@' --debug 1

netid/%.ppm: $(CSV)
	mkdir -p netid
	rm -f '$@'
	cd netid &&  ln -s '../$(basename $(shell grep -l $* $+)).ppm/i-$(shell grep -h $* $$(grep -l $* $+) | cut -f 1 -d ,).ppm' '$(notdir $@)'

.link: $(CSV)
	rm -rf netid
	$(MAKE) .link-r
	touch $@

.link-r: $(LINK)
	touch $@

.png: .csv .ppm
	$(MAKE) .png-r
	touch $@

.png-r: $(PNG)
	touch $@

netid/%.png: netid/%.ppm
	convert $< $@

.verify: .png always 
	evince $(PDF) &
	$(MAKE) .verify-r
	touch $@

.verify-r: $(VERIFY)
	touch $@

%.verify: %.png
	display $< & echo $$! > $*.pid
	if zenity --question --text='Is it $(notdir $*)?'; then touch $@; fi
	kill $$(< $*.pid) || true
	rm -f $*.pid

always: ;

