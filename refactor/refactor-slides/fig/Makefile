PLANTC=../../build-tools/plantuml.jar
SRC:= bad-class.iuml good-class.iuml merged-class.iuml
PNG:= ${SRC:.iuml=.png}

all: $(PNG)

%.png : %.iuml
	java -jar $(PLANTC) $< 
