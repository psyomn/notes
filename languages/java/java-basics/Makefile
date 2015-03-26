FILES:=version.markdown \
       introduction.markdown \
       basic-oop.markdown \
       advanced-oop.markdown \
       abstract-classes.markdown \
       templates.markdown \

all:
	pandoc -V geometry:margin=1in \
	  --number-section            \
	  --variable fontsize=12pt    \
	  $(FILES)                    \
	  metadata.yaml               \
	  -o java-basics.pdf

