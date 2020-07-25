.PHONY: clean

all: notes.pdf notes.html notes.epub

notes.pdf: notes/*.md
	pandoc -N --toc -s -t ms $^ -o $@

notes.html: notes/*.md
	pandoc -N --toc -s -t html5 $^ -o $@

notes.epub: notes/*.md
	pandoc -N --toc -s $^ -o $@

clean:
	rm -f notespdf notes.html notes.epub
