PFLAGS=-Vgeometry:margin=1in

all: pdf

pdf:
	pandoc $(PFLAGS) music-software.markdown -o music-software.pdf

html:
	pandoc $(PFLAGS) music-software.markdown -o music-software.html

epub:
	pandoc $(PFLAGS) music-software.markdown -o music-software.epub

txt:
	pandoc $(PFLAGS) music-software.markdown -o music-software.txt
