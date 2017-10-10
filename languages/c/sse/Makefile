all: slides programs

programs:
	gcc -O3 -std=c11 main.c -o main

slides:
	pdflatex -output-directory ./work/ slides.tex
