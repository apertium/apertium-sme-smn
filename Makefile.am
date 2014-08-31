###############################################################################
## Makefile for Northern Sámi--Inari Sámi
###############################################################################

VERSION=0.1.0
LANG1=sme
LANG2=smn
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

##
##	BUILD TARGETS
##

TARGETS_COMMON = \
	$(PREFIX1).automorf.hfst \
	$(PREFIX2).autogen.hfst \
	$(PREFIX1).mor.rlx.bin \
	$(PREFIX1).syn.rlx.bin \
	$(PREFIX1).autobil.bin \
	$(PREFIX1).autolex.bin \
	$(PREFIX2).autobil.bin \
	$(PREFIX1).autogen.hfst \
	$(PREFIX2).automorf.hfst

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

debug: \
	$(BASENAME).$(PREFIX1).mor.rlx \
	$(BASENAME).$(PREFIX1).syn.rlx \
	$(BASENAME).$(PREFIX2).rlx

###############################################################################
## Transducers, disambiguation rules, transfer
###############################################################################

##
## 	SME ANALYSER DICTIONARY
##

.deps/$(PREFIX1).autobil.prefixes: $(PREFIX1).autobil.bin .deps/.d
	lt-print $< | sed 's/ /@_SPACE_@/g' > .deps/$(PREFIX1).autobil.att
	hfst-txt2fst -e ε <  .deps/$(PREFIX1).autobil.att > .deps/$(PREFIX1).autobil.hfst
	hfst-project -p upper .deps/$(PREFIX1).autobil.hfst > .deps/$(PREFIX1).autobil.upper
	echo " ?* " | hfst-regexp2fst > .deps/any-symbol.hfst
	hfst-concatenate -1 .deps/$(PREFIX1).autobil.upper -2 .deps/any-symbol.hfst -o $@

.deps/$(LANG1).automorf.hfst: $(AP_SRC1)/$(BASENAME).$(PREFIX1).LR.att.gz .deps/.d
	$(ZCAT) $< | hfst-txt2fst > $@

.deps/$(LANG1).autogen.hfst: .deps/$(LANG1).automorf.hfst
	hfst-invert -i $< -o $@

.deps/$(PREFIX1).automorf.hfst: .deps/$(LANG1).automorf.hfst .deps/$(PREFIX1).autobil.prefixes
	hfst-compose-intersect -1 .deps/$(LANG1).automorf.hfst -2 .deps/$(PREFIX1).autobil.prefixes -o $@

$(PREFIX1).automorf.hfst: .deps/$(PREFIX1).automorf.hfst
	hfst-fst2fst -O -i $< -o $@

$(PREFIX2).autogen.hfst: .deps/$(LANG1).autogen.hfst
	hfst-fst2fst -O -i $< -o $@
##
## 	SMN ANALYSER DICTIONARY
##

.deps/$(PREFIX2).autobil.prefixes: $(PREFIX2).autobil.bin .deps/.d
	lt-print $< | sed 's/ /@_SPACE_@/g' > .deps/$(PREFIX2).autobil.att
	hfst-txt2fst -e ε <  .deps/$(PREFIX2).autobil.att > .deps/$(PREFIX2).autobil.hfst
	hfst-project -p upper .deps/$(PREFIX2).autobil.hfst > .deps/$(PREFIX2).autobil.upper
	echo " ?* " | hfst-regexp2fst > .deps/any-symbol.hfst
	hfst-concatenate -1 .deps/$(PREFIX2).autobil.upper -2 .deps/any-symbol.hfst -o $@

.deps/$(LANG2).automorf.hfst: $(AP_SRC2)/$(BASENAME).$(PREFIX2).LR.att.gz .deps/.d
	$(ZCAT) $< | hfst-txt2fst > $@

.deps/$(LANG2).autogen.hfst: .deps/$(LANG2).automorf.hfst
	hfst-invert -i $< -o $@

.deps/$(PREFIX2).automorf.hfst: .deps/$(LANG2).automorf.hfst .deps/$(PREFIX2).autobil.prefixes
	hfst-compose-intersect -1 .deps/$(LANG2).automorf.hfst -2 .deps/$(PREFIX2).autobil.prefixes -o $@

$(PREFIX2).automorf.hfst: .deps/$(PREFIX2).automorf.hfst
	hfst-fst2fst -O -i $< -o $@

$(PREFIX1).autogen.hfst: .deps/$(LANG2).autogen.hfst
	hfst-fst2fst -O -i $< -o $@



##
## 	BILINGUAL DICTIONARY
###
#.deps/$(BASENAME).$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix lexchoicebil.xsl .deps/.d
#	apertium-validate-dictionary $<
#	xsltproc lexchoicebil.xsl $(BASENAME).$(PREFIX1).dix > $@

#$(PREFIX1).autobil.bin: .deps/$(BASENAME).$(PREFIX1).dix
$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

#$(PREFIX2).autobil.bin: .deps/$(BASENAME).$(PREFIX1).dix
$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

##
##	PRE-TAGGING
##

$(PREFIX1).mor.rlx.bin: $(AP_SRC1)/$(LANG1).mor.rlx.bin
	cp $< $@

$(PREFIX1).syn.rlx.bin: $(AP_SRC1)/$(LANG1).syn.rlx.bin
	cp $< $@

# CG sources for debug modes:
$(BASENAME).$(PREFIX1).mor.rlx: $(AP_SRC1)/disambiguation-mt-apertium.cg3
	cp $< $@

$(BASENAME).$(PREFIX1).syn.rlx: $(AP_SRC1)/functions-mt-apertium.cg3
	cp $< $@

## 
##	LEXICAL SELECTION
##

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

###############################################################################
## Distribution
###############################################################################

# Files which aren't built, but are distributed:
EXTRA_DIST=\
	$(BASENAME).$(PREFIX1).dix \
	modes.xml 

###############################################################################
## Installation
###############################################################################

apertium_sme_smndir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_sme_smn_DATA=$(TARGETS_COMMON) 

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local: install-modes


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes
