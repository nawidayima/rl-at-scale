.PHONY: all studyguide workbook textbook clean

all: studyguide workbook textbook

studyguide: build/studyguide.pdf
workbook: build/workbook.pdf
textbook: build/textbook.pdf

build/studyguide.pdf: studyguide.tex preamble.tex studyguide/*.tex
	mkdir -p build
	tectonic studyguide.tex -o build

build/workbook.pdf: workbook.tex preamble.tex workbook/*.tex
	mkdir -p build
	tectonic workbook.tex -o build

build/textbook.pdf: textbook.tex preamble.tex studyguide/*.tex workbook/*.tex
	mkdir -p build
	tectonic textbook.tex -o build

clean:
	rm -rf build
