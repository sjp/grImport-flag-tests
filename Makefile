STATES = $(basename $(shell ls svg))

OUTDIRS = ps-thumbs svg-thumbs cairosvg-thumbs \
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

# Add GRIMPORT_IMPROVED_THUMBNAILS later
all: $(TABLE) $(PS_THUMBNAILS) $(SVG_THUMBNAILS) $(CAIRO_SVG_THUMBNAILS) \
	 $(GRIMPORT_THUMBNAILS) \
	 $(GRIMPORT_IMPROVED_FILES) $(GRIMPORT_IMPROVED_THUMBNAILS) \
	 $(GRIMPORT2_FILES) $(GRIMPORT2_THUMBNAILS) \
	 $(GRIMPORT2_GRIDSVG_FILES) $(GRIMPORT2_GRIDSVG_THUMBNAILS) $(TABLE)
	@echo "**"
	@echo "** Page built: $(TABLE)"
	@echo "**"

# Initial thumbnails
ps-thumbs/%.png: ps/%.ps
	@evince-thumbnailer -s 300 $< $@

svg-thumbs/%.png: svg/%.svg
	@inkscape -z -e $@ -C -w 300 $<

cairosvg-thumbs/%.png: cairosvg/%.svg
	@inkscape -z -e $@ -C -w 300 $<

# Time to generate the images themselves
grImport/%.pdf: ps/%.ps
	@R -e "source('R/grImport.R') ; renderPDF('$<', '$@')"

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

clean:
	@-rm -rf state-table.html ps-thumbs svg-thumbs cairosvg-thumbs \
		grImport-thumbs \
		grImport-improved grImport-improved-thumbs \
		grImport2 grImport2-thumbs \
		grImport2-gridSVG grImport2-gridSVG-thumbs

.PHONY: all clean outdirs
