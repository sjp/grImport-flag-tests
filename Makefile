STATES = $(basename $(shell ls svg))

OUTDIRS = svg-thumbs \
	ps ps-thumbs \
	cairosvg cairosvg-thumbs \
	grImport grImport-thumbs \
	grImport-improved grImport-improved-thumbs \
	grImport2 grImport2-thumbs \
	grImport2-gridSVG grImport2-gridSVG-thumbs

PS_FILES = $(addprefix ps/, $(addsuffix .ps, $(STATES)))
PS_THUMBNAILS = $(addprefix ps-thumbs/, $(addsuffix .png, $(STATES)))

SVG_FILES = $(addprefix svg/, $(addsuffix .svg, $(STATES)))
SVG_THUMBNAILS = $(addprefix svg-thumbs/, $(addsuffix .png, $(STATES)))

CAIRO_SVG_FILES = $(addprefix cairosvg/, $(addsuffix .svg, $(STATES)))
CAIRO_SVG_THUMBNAILS = $(addprefix cairosvg-thumbs/, \
	$(addsuffix .png, $(STATES)))

GRIMPORT_FILES = $(addprefix grImport/, $(addsuffix .pdf, $(STATES)))
GRIMPORT_THUMBNAILS = $(addprefix grImport-thumbs/, \
	$(addsuffix .png, $(STATES)))

GRIMPORT_IMPROVED_FILES = $(addprefix grImport-improved/, \
	$(addsuffix .pdf, $(STATES)))
GRIMPORT_IMPROVED_THUMBNAILS = $(addprefix grImport-improved-thumbs/, \
	$(addsuffix .png, $(STATES)))

GRIMPORT2_FILES = $(addprefix grImport2/, $(addsuffix .pdf, $(STATES)))
GRIMPORT2_THUMBNAILS = $(addprefix grImport2-thumbs/, \
	$(addsuffix .png, $(STATES)))

GRIMPORT2_GRIDSVG_FILES = $(addprefix grImport2-gridSVG/, \
	$(addsuffix .svg, $(STATES)))
GRIMPORT2_GRIDSVG_THUMBNAILS = $(addprefix grImport2-gridSVG-thumbs/, \
	$(addsuffix .png, $(STATES)))

# Also need to generate a final table
TABLE = state-table.html

# Double colon for explicit ordering of rules
# i.e. dirs are always present before the page is generated
all:: outdirs page 

page: $(TABLE) $(SVG_THUMBNAILS) \
	  $(PS_FILES) $(PS_THUMBNAILS) \
	  $(CAIRO_SVG_FILES) $(CAIRO_SVG_THUMBNAILS) \
	  $(GRIMPORT_THUMBNAILS) \
	  $(GRIMPORT_IMPROVED_FILES) $(GRIMPORT_IMPROVED_THUMBNAILS) \
	  $(GRIMPORT2_FILES) $(GRIMPORT2_THUMBNAILS) \
	  $(GRIMPORT2_GRIDSVG_FILES) $(GRIMPORT2_GRIDSVG_THUMBNAILS)
	@echo "**"
	@echo "** Page built: $(TABLE)"
	@echo "**"

# Initial thumbnails
svg-thumbs/%.png: svg/%.svg
	@inkscape -z -e $@ -C -w 300 $<

# To be generated later
cairosvg-thumbs/%.png: cairosvg/%.svg
	@inkscape -z -e $@ -C -w 300 $<

ps-thumbs/%.png: ps/%.ps
	@evince-thumbnailer -s 300 $< $@

# Generate source images via grConvert
ps/%.ps: svg/%.svg
	@R -e "source('R/grConvert.R') ; createImage('$<', '$@')"

cairosvg/%.svg: svg/%.svg
	@R -e "source('R/grConvert.R') ; createImage('$<', '$@')"

# Time to generate the images themselves
#
# Ignore grImport as that has already been pre-generated.
# The same code used to generate the image however, is present
# in R/grImport-improved.R
#grImport/%.pdf: ps/%.ps
#	@R -e "source('R/grImport.R') ; renderPDF('$<', '$@')"

grImport-improved/%.pdf: ps/%.ps
	@R -e "source('R/grImport-improved.R') ; renderPDF('$<', '$@')"

grImport2/%.pdf: cairosvg/%.svg
	@R -e "source('R/grImport2.R') ; renderPDF('$<', '$@')"

grImport2-gridSVG/%.svg: cairosvg/%.svg
	@R -e "source('R/grImport2-gridSVG.R') ; renderSVG('$<', '$@')"

# Generate the thumbnails for them
grImport-thumbs/%.png: grImport/%.pdf
	@evince-thumbnailer -s 300 $< $@

grImport-improved-thumbs/%.png: grImport-improved/%.pdf
	@evince-thumbnailer -s 300 $< $@

grImport2-thumbs/%.png: grImport2/%.pdf
	@evince-thumbnailer -s 300 $< $@

grImport2-gridSVG-thumbs/%.png: grImport2-gridSVG/%.svg
	@inkscape -z -e $@ -C -w 300 $<

# Finally create the table that shows off all of these things
state-table.html: R/state-table-template.Rhtml R/table-gen-brew.R
	@R -e "source('R/table-gen-brew.R') ; library(brew) ; brew('$<', '$@')"

outdirs:
	@-mkdir -p $(OUTDIRS)

compress: all
	@optipng -o7 $(SVG_THUMBNAILS) $(PS_THUMBNAILS) $(CAIRO_SVG_THUMBNAILS) \
	   	$(GRIMPORT_THUMBNAILS) $(GRIMPORT_IMPROVED_THUMBNAILS) \
		$(GRIMPORT2_THUMBNAILS) $(GRIMPORT2_GRIDSVG_THUMBNAILS)

clean:
	@-rm -rf state-table.html ps-thumbs svg-thumbs cairosvg-thumbs \
		grImport-thumbs \
		grImport-improved grImport-improved-thumbs \
		grImport2 grImport2-thumbs \
		grImport2-gridSVG grImport2-gridSVG-thumbs

.PHONY: all clean outdirs compress page
