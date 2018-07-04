TEXOPTIONS=--output-directory build/

all: make-build-dirs make-document memo

make-document:
	pdflatex $(TEXOPTIONS) main.tex
	pdflatex $(TEXOPTIONS) main.tex

make-bib:
	@echo 'biber coming soon'

make-build-dirs:
	mkdir -p build

share:
	@mkdir -p release-papers
	cp build/main.pdf release-papers/cobalt-$(shell date +%d-%m-%Y-%Hh%M).pdf

memo:
	@echo "don't forget to run make --help (eg make share)"

todo:
	@grep -iRn todo
