FILES:=minibattle.markdown

all:
	pandoc -V geometry:margin=1in \
	  --number-section            \
	  --variable fontsize=12pt    \
	  $(FILES)                    \
	  metadata.yaml               \
	  -o minibattle.pdf

