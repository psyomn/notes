SRC := sqlite3-notes.markdown
PANDOCFLAGS=-V geometry:margin=1.0in
all: 
	make -C fig
	pandoc $(PANDOCFLAGS) $(SRC) -o sql-notes.pdf

