SRC:= has-many.dot has-one.dot
IMG:= $(SRC:.dot=.png)

all: $(IMG)

%.png : %.dot
	dot -Tpng $< > $@
	
