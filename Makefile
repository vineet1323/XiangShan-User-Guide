VERSION = $(shell git describe --always)

MAIN_MD = pandoc-main.md
SRCS = $(wildcard docs/*.md)

SVG_FIGS := $(wildcard docs/figs/*.svg)
PDF_FIGS := $(patsubst docs/figs/%.svg, build/docs/figs/%.pdf, $(SVG_FIGS))

DEPS =
DEPS += $(wildcard utils/*.lua)
DEPS += utils/template.tex

PANDOC_FLAGS += --variable=version:"$(VERSION)"
PANDOC_FLAGS += --from=markdown+table_captions+multiline_tables+grid_tables+header_attributes-implicit_figures
PANDOC_FLAGS += --table-of-contents
PANDOC_FLAGS += --number-sections
PANDOC_FLAGS += --lua-filter=include-files.lua
PANDOC_FLAGS += --metadata=include-auto
PANDOC_FLAGS += --lua-filter=utils/pandoc_filters/replace_variables.lua
PANDOC_FLAGS += --lua-filter=utils/pandoc_filters/remove_md_links.lua
PANDOC_FLAGS += --filter pandoc-crossref

PANDOC_LATEX_FLAGS += --top-level-division=chapter
PANDOC_LATEX_FLAGS += --pdf-engine=xelatex
PANDOC_LATEX_FLAGS += --lua-filter=utils/pandoc_filters/svg_to_pdf.lua
PANDOC_LATEX_FLAGS += --template=utils/template.tex

PANDOC_HTML_FLAGS += --embed-resources
PANDOC_HTML_FLAGS += --shift-heading-level-by=1

all: xiangshan-user-guide.pdf xiangshan-user-guide.html

clean:
	rm -f xiangshan-user-guide.tex xiangshan-user-guide.pdf *.aux *.log *.toc
	rm -rf build

build/docs/figs/%.pdf: docs/figs/%.svg
	mkdir -p build/docs/figs
	rsvg-convert -f pdf -o $@ $<

xiangshan-user-guide.tex: $(MAIN_MD) $(SRCS) $(DEPS)
	pandoc $(MAIN_MD) $(PANDOC_FLAGS) $(PANDOC_LATEX_FLAGS) -s -o $@
	sed -i 's/@{}//g' $@

xiangshan-user-guide.html: $(MAIN_MD) $(SRCS) $(DEPS) $(SVG_FIGS)
	pandoc -s $(MAIN_MD) $(PANDOC_FLAGS) $(PANDOC_HTML_FLAGS) -o $@

xiangshan-user-guide.pdf: xiangshan-user-guide.tex $(PDF_FIGS)
	xelatex $^
	xelatex $^
	xelatex $^

.PHONY: all clean
