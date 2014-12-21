all: obj bin1 bin2

clean:
	rm *.o

obj:
	gcc -c main.c
	gcc -c lib_impl_1.c
	gcc -c lib_impl_2.c

bin1:
	gcc main.o lib_impl_1.o -o main_with_lib1

bin2:
	gcc main.o lib_impl_2.o -o main_with_lib2
