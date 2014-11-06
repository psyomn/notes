SRC:= has-many.dot has-one.dot has-many-through.dot
IMG:= $(SRC:.dot=.png)

all: $(IMG)

%.png : %.dot
	dot -Tpng $< > $@
	
