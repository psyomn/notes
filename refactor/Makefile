SRC := refactor-13-01-2014.markdown
PDF := $(SRC:.markdown=.pdf)

all: $(PDF)

%.pdf : %.markdown
	pandoc -t beamer $< -o $@
