PFLAGS=-V geometry:margin=1in --number-section --variable fontsize=12pt --listings

all:
	pandoc \
	$(PFLAGS) \
	version.markdown \
	ocl-ruby.markdown \
	metadata.yaml \
	-o ocl-ruby.pdf
