SRC := refactor-13-01-2014.markdown
PDF := $(SRC:.markdown=.pdf)

all: fig $(PDF)

%.pdf : %.markdown
	pandoc -t beamer $< -o $@

fig:
	make -C fig/
