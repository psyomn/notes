% Compiling and Linking with GCC
% Simon Symeonidis
% Sat Dec 20 20:27:44 EST 2014

# Introduction

These are minor notes about compiling and linking. Background is that originally
computers were quite slow, and compiling C code was expensive in terms of
cycles. They broke down the compilation process of bigger projects by generating
object code per module / file. Essentially you used the compiler to do this.
When you had all the required object code, you use a linker to combine
everything in one binary.

With the above being said, I wanted to do a pretty simple experiment. When you
include files in C, essentially you are importing all the function signatures,
but disregarding the implementation. The implementation is written in the \*.c
file, and that is what is compiled to object code.

So essentially object code has operations local to itself, and symbols refering
to functionalities outside the object. For example you could have an
implementation relying on another header file. The linker should put all this
together, and give you a fully working binary.

# Source and Notes Location

All notes, and source code is here:

> [https://github.com/psyomn/architecture-notes/blob/master/languages/c/diff-link/diff-link.markdown][ghlink]

[ghlink]: https://github.com/psyomn/architecture-notes/blob/master/languages/c/diff-link/diff-link.markdown

# Experiment

The experiment is simple. Since everything relies on the header files and
symbols, then it should be possible to have two different implementations for
the same header file. So, first let us define the header file. We name this
`lib_spec.h`:

~~~~c
    #ifndef LIB_SPEC_H
    #define LIB_SPEC_H

    void
    print_message();

    int
    add(int, int);

    #endif /* LIB_SPEC_H */
~~~~

And now, let us define the main entry point:

~~~~c
    #include <stdio.h>
    #include "lib_spec.h"

    int
    main(void) {
      print_message();
      printf("1 + 2 = %d\n", add(1,2));
      return 0;
    }
~~~~

Even though we do not know what the implementation of each function we call is,
we can get an overall idea on how the application should behave.

It is legal to compile the `main.c` file even without the implementation given
by the `lib_spec.h` header.

~~~~nocode
    $ gcc -c main.c
    $ ls
    main.c main.o
~~~~

Cool. Now we just need to provide an implementation for the `lib_spec.h` file.
Let us do a 'normal' implementation. The file will be called `lib_impl_1.c`:

~~~~c
    #include <stdio.h>
    #include "lib_spec.h"

    void
    print_message() {
      printf("%s\n", "What a lovely library");
    }

    int
    add(int a, int b) {
      return a + b;
    }
~~~~

We can now compile this as well:

~~~~nocode
    $ gcc -c lib_impl_1.c
~~~~

We have all parts needed to compile the whole project into an executable binary
now. We need a linker to combine all the object code. The `gcc` compiler is
_also a linker_, which means we can use it to link, and create the binary. We do
this by combining all the object code, and outputing to a final file (binary):

~~~~nocode
    $ gcc main.o lib_impl_1.o -o main_with_lib1
~~~~

And if we execute the code, we get the following output:

~~~~nocode
    What a lovely library
    1 + 2 = 3
~~~~

Now let's implement another definition for the specification of the `lib_spec.h`
file:

~~~~nocode
    #include <stdio.h>
    #include "lib_spec.h"

    void
    print_message() {
      printf("Badly implemented library!!\n"
          "Add is not add!!i\n");
    }

    int
    add(int potato, int yotato) {
      return potato + yotato - 1;
    }
~~~~

We don't need to re-compile main.o. The only thing we need to do is compile the
alternate library, and link it with the main.o object code.

~~~~nocode
    $ gcc -c lib_impl_2.c
    $ gcc main.o lib_impl_2.o -o main_with_lib2
~~~~

And as you'd expect, you get the following output:

~~~~nocode
    Badly implemented library!!
    Add is not add!!i
    1 + 2 = 2
~~~~

