all:
	ghc main.hs -odir obj/ -hidir hi/

clean:
	rm -rf hi obj hi-opt obj-opt;

opt: clean
	ghc -O3 main.hs -odir obj-opt -hidir hi-opt/ 

# Replace with your image viewer
s: all
	./main > out.ppm;
	feh out.ppm

doc:
	doxygen 
