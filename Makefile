.PHONY: textbook all-chapters clean

textbook: build/textbook.pdf

build/textbook.pdf: textbook.tex preamble.tex chapters/*.tex
	mkdir -p build
	tectonic textbook.tex -o build

# Standalone chapter: make ch=00-introduction
ifdef ch
build/$(ch).pdf: standalone.tex preamble.tex chapters/$(ch).tex
	mkdir -p build
	sed 's|\\input{\\chapterfile}|\\input{chapters/$(ch)}|' standalone.tex > _ch_tmp.tex
	tectonic -Z shell-escape _ch_tmp.tex -o build
	mv build/_ch_tmp.pdf build/$(ch).pdf
	rm -f _ch_tmp.tex

.PHONY: chapter
chapter: build/$(ch).pdf
.DEFAULT_GOAL := chapter
endif

all-chapters:
	@for f in chapters/[0-9]*.tex; do \
		name=$$(basename $$f .tex); \
		echo "Building $$name..."; \
		mkdir -p build; \
		sed "s|\\\\input{\\\\chapterfile}|\\\\input{chapters/$$name}|" standalone.tex > _ch_tmp.tex && \
		tectonic -Z shell-escape _ch_tmp.tex -o build && \
		mv build/_ch_tmp.pdf build/$$name.pdf; \
		rm -f _ch_tmp.tex; \
	done

clean:
	rm -rf build
