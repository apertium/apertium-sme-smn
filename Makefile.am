###############################################################################
## Makefile for Northern Saami--Inari Saami
###############################################################################

LANG1=sme
LANG2=smn
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON =			\
	$(PREFIX1).automorf.hfst	\
	$(PREFIX1).automorf-untrimmed.hfst \
	$(PREFIX1).mor.rlx.bin		\
	$(PREFIX1).syn.rlx.bin		\
	$(PREFIX1).autobil.bin		\
	$(PREFIX1).autolex.bin		\
	$(PREFIX1).autogen.hfst		\
	$(PREFIX1).t1x.bin		\
	$(PREFIX1).t2x.bin		\
	$(PREFIX1).t3x.bin		\
	$(PREFIX1).t4x.bin		\
	$(PREFIX1).t5x.bin		\
	$(PREFIX2).automorf.hfst	\
	$(PREFIX2).automorf-untrimmed.hfst \
	$(PREFIX2).mor.rlx.bin		\
	$(PREFIX2).syn.rlx.bin		\
	$(PREFIX2).autobil.bin		\
	$(PREFIX2).autolex.bin		\
	$(PREFIX2).autogen.hfst		\
	$(PREFIX2).t1x.bin		\
	$(PREFIX2).t2x.bin		\
	$(PREFIX2).t3x.bin		\
	$(PREFIX2).t4x.bin		\
	$(PREFIX2).t5x.bin


# This include defines goals for install-modes, .deps/.d, autobil.prefixes and .mode files:
@ap_include@

###############################################################################
## Monolingual transducers
###############################################################################

# Override prefixes from ap_include, since we need the derivation-pos-changes:
.deps/%.autobil.prefixes: %.autobil.bin .deps/.d
	lt-print $< | sed 's/ /@_SPACE_@/g' > .deps/$*.autobil.att
	hfst-txt2fst -e ε -i  .deps/$*.autobil.att -o .deps/$*.autobil.hfst
	hfst-project -p upper .deps/$*.autobil.hfst -o .deps/$*.autobil.upper                                   # bidix
	echo '[ "<n>" -> [ "<n>" | "<ex_n>" ] ] .o. [ "<adj>" -> [ "<adj>" | "<ex_adj>" ] ] .o. [ "<vblex>" -> [ "<vblex>" |"<ex_vblex>" ] ] .o. [ "<iv>" -> [ "<iv>" | "<ex_iv>" ] ] .o. [ "<tv>" -> [ "<tv>" | "<ex_tv>" ] ]' \
		| hfst-regexp2fst -o .deps/$*.derivpos.hfst
	hfst-compose -1 .deps/$*.autobil.upper -2 .deps/$*.derivpos.hfst -o .deps/$*.autobil-derivpos.hfst
	hfst-project -p lower .deps/$*.autobil-derivpos.hfst -o .deps/$*.autobil-derivpos.hfsa                  # bidix with n -> n|ex_n
	echo ' [ ? - %+ ]* ' | hfst-regexp2fst > .deps/$*.any-nonplus.hfst                                                        # [^+]*
	hfst-concatenate -1 .deps/$*.autobil-derivpos.hfsa -2 .deps/$*.any-nonplus.hfst -o .deps/$*.autobil.nonplussed    # bidix [^+]*
	echo ' %+ ' | hfst-regexp2fst > .deps/$*.single-plus.hfst                                                                 # +
	hfst-concatenate -1 .deps/$*.single-plus.hfst -2 .deps/$*.autobil.nonplussed -o .deps/$*.autobil.postplus # + bidix [^+]*
	hfst-repeat -f0 -t3 -i .deps/$*.autobil.postplus -o .deps/$*.autobil.postplus.0,3                      # (+ bidix [^+]*){0,3} -- gives at most three +
	hfst-concatenate -1 .deps/$*.autobil.nonplussed -2 .deps/$*.autobil.postplus.0,3 -o $@                 # bidix [^+]* (+ bidix [^+]*){0,3}

# -------------------
# Northern Saami analysis:
# -------------------

.deps/$(LANG1).automorf.hfst: $(AP_SRC1)/apertium-und.$(LANG1)-und.LR.att.gz .deps/.d
	$(ZCAT) $< | hfst-txt2fst > $@

.deps/$(PREFIX1).automorf-trimmed.hfst: .deps/$(LANG1).automorf.hfst .deps/$(PREFIX1).autobil.prefixes
	hfst-compose-intersect -1 $< -2 .deps/$(PREFIX1).autobil.prefixes -o $@

.deps/rm-deriv-cmp.hfst: rm-deriv-cmp.twol .deps/.d
	hfst-twolc -i $< -o $@

.deps/$(PREFIX1).automorf-trimmed-rmderiv.hfst: .deps/$(PREFIX1).automorf-trimmed.hfst .deps/rm-deriv-cmp.hfst
	hfst-compose-intersect -1 $< -2 .deps/rm-deriv-cmp.hfst -o $@

$(PREFIX1).automorf.hfst: .deps/$(PREFIX1).automorf-trimmed-rmderiv.hfst
	hfst-fst2fst -w -i $< -o $@

$(PREFIX1).automorf-untrimmed.hfst: .deps/$(LANG1).automorf.hfst
	hfst-fst2fst -w -i $< -o $@

# -------------------
# Northern Saami generation:
# ---------------------

$(PREFIX2).autogen.hfst: $(AP_SRC1)/apertium-$(LANG1).$(LANG1).RL.att.gz
	$(ZCAT) $< | hfst-txt2fst -f optimized-lookup-weighted -o $@


# -------------------
# Inari Saami analysis:
# -------------------

.deps/$(LANG2).automorf.hfst: $(AP_SRC2)/$(BASENAME).$(PREFIX2).LR.att.gz .deps/.d
	$(ZCAT) $< | hfst-txt2fst > $@

.deps/$(PREFIX2).automorf-trimmed.hfst: .deps/$(LANG2).automorf.hfst .deps/$(PREFIX2).autobil.prefixes
	hfst-compose-intersect -1 $< -2 .deps/$(PREFIX2).autobil.prefixes -o $@

$(PREFIX2).automorf.hfst: .deps/$(PREFIX2).automorf-trimmed.hfst
	hfst-fst2fst -w -i $< -o $@

$(PREFIX2).automorf-untrimmed.hfst: .deps/$(LANG2).automorf.hfst
	hfst-fst2fst -w -i $< -o $@

# -------------------
# Inari Saami generation:
# ---------------------

$(PREFIX1).autogen.hfst: $(AP_SRC2)/apertium-$(LANG2).$(LANG2).RL.att.gz
	$(ZCAT) $< | hfst-txt2fst -f optimized-lookup-weighted -o $@


###############################################################################
## Disambiguation rules
###############################################################################

$(PREFIX1).mor.rlx.bin: $(AP_SRC1)/$(LANG1).mor.rlx.bin 
	cp $< $@

$(PREFIX1).syn.rlx.bin: $(AP_SRC1)/$(LANG1).syn.rlx.bin 
	cp $< $@


$(PREFIX2).mor.rlx.bin: $(AP_SRC2)/$(LANG2).mor.rlx.bin 
	cp $< $@

$(PREFIX2).syn.rlx.bin: $(AP_SRC2)/$(LANG2).syn.rlx.bin 
	cp $< $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	apertium-validate-lrx $<
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	apertium-validate-lrx $<
	lrx-comp $< $@

###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t4x.bin: $(BASENAME).$(PREFIX1).t4x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t5x.bin: $(BASENAME).$(PREFIX1).t5x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@


$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t4x.bin: $(BASENAME).$(PREFIX2).t4x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t5x.bin: $(BASENAME).$(PREFIX2).t5x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@


###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=					\
		$(BASENAME).$(PREFIX1).dix	\
		$(BASENAME).$(PREFIX1).t1x	\
		$(BASENAME).$(PREFIX1).t2x	\
		$(BASENAME).$(PREFIX1).t3x	\
		$(BASENAME).$(PREFIX1).t4x	\
		$(BASENAME).$(PREFIX1).t5x	\
		$(BASENAME).$(PREFIX2).t1x	\
		$(BASENAME).$(PREFIX2).t2x	\
		$(BASENAME).$(PREFIX2).t3x	\
		$(BASENAME).$(PREFIX2).t4x	\
		$(BASENAME).$(PREFIX2).t5x	\
		modes.xml

###############################################################################
## Installation
###############################################################################

apertium_sme_smndir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_sme_smn_DATA=	\
	$(TARGETS_COMMON)				\
	$(BASENAME).$(PREFIX1).t1x			\
	$(BASENAME).$(PREFIX1).t2x			\
	$(BASENAME).$(PREFIX1).t3x			\
	$(BASENAME).$(PREFIX1).t4x			\
	$(BASENAME).$(PREFIX1).t5x			\
	$(BASENAME).$(PREFIX2).t1x			\
	$(BASENAME).$(PREFIX2).t2x			\
	$(BASENAME).$(PREFIX2).t3x			\
	$(BASENAME).$(PREFIX2).t4x			\
	$(BASENAME).$(PREFIX2).t5x

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local: install-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test-install:
	DESTDIR=tmp-$@ make install
	find tmp-$@ -type f -name '*.mode' | xargs sed -i.tmp "s% '\($(prefix)\)% 'tmp-$@/\1%g"
	echo "ja" | apertium -d tmp-$@/$(prefix)/share/apertium sme-smn | tee tmp-$@/mt
	@echo "já" > tmp-$@/ref
	@diff tmp-$@/ref tmp-$@/mt
	echo "já" | apertium -d tmp-$@/$(prefix)/share/apertium smn-sme | tee tmp-$@/mt
	@echo "ja" > tmp-$@/ref
	@diff tmp-$@/ref tmp-$@/mt
	@rm -rf tmp-$@

test: all test-install
	apertium-regtest test
