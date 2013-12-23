
mkdir -p build-tools/

if [ ! -f build-tools/plantuml.jar ]; then 
  wget -O build-tools/plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
fi 

