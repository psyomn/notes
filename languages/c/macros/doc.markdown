% Macros in the C Programming Language
% Simon Symeonidis
% Sat Jan 31 19:30:56 EST 2015

# Introduction

I aim to cover some basic things about macros, uses, and gotchas in this simple
writeup. I may give a good general advice about macros, but I am not a
professional in C. Some other resources might give better information and
you're encouraged to take a look [cxxfaq]. These notes may be located here:

> [https://github.com/psyomn/architecture-notes/blob/master/languages/c/macros/doc.markdown][doc-gh-link]

[doc-gh-link]: https://github.com/psyomn/architecture-notes/blob/master/languages/c/macros/doc.markdown

# Using macros

To use macros, you need to use the `#define` preprocessor statement outside code
blocks. A `#define` basically will replace one part with the other when the
preprocessor of the C compiler scans over the code. A `#define` has the
following format:

> \#define \<blob-to-replace\> \<replace-with-this\>

So the following statement will replace any occurrence of 'MY\_MACRO\_DEF' with
10.

~~~~C
    #define MY_MACRO_DEF 10
    int main(void) {
      printf("%d\n", MY_MACRO_DEF);
    }
~~~~

In fact you can replace macro definitions with strings as well:

~~~~C
    #define MY_MACRO_DEF "my string is a macro"
    int main(void) {
      printf("%s\n", MY_MACRO_DEF);
    }
~~~~

Actually, there's no semantic checks. You can pretty much add anything you want
on the second argument of `#define`, and when your macro definition is found in
the source, it will be expanded to whatever. So for example, if you want to get
rid of curly braces in your `C` code you could do something like this:

~~~~C
    /* examples/scriptlike_c.c */
    #define begin {
    #define end }
    #define mod %
    #define eq ==

    int main() {
        int x;
        for(x = 0; x < 10; ++x) begin
            if (x mod 2 eq 0) begin
            // ...
            end
        end
    }
~~~~

The above is legal. But it is not recommended to use for obvious reasons. If you
start defining too many things, maybe some definitions will start clashing with
other definitions you import. I should stress that this is not recommended
practice.

# Before we dive into Macros

If you are the practical kind of person and want to check the expansions for
yourself and are using `gcc`, you can do the following in order to check the
results from your macros:

~~~~
    gcc -E source.c
~~~~

That should print out the results of what happens when the preprocessor goes
over your code (and in turn expand macros).

## Using Macros for Values

Many times you will see macros being used to replace values in code. This is
done simply as previously stated:

~~~~c
    #define MY_VAL_MAC 12
    int main(void) {
        printf("%d\n", MY_VAL_MAC);
    }
~~~~

## Using Macros to replace with Code

There might be cases where you want to inject source code using a macro. The use
case for such a feature is to provide better performance by reducing jumps to
functions. The classical example is the `MIN` or `MAX` macro.

~~~~C
    #define MIN(X, Y) X < Y ? X : Y
    int main(void) {
      int a = 1, b = 3;
      printf("%s%d\n", "Smallest number is : ", MIN(a,b));
    }
~~~~

Which essentially, when the preprocessor goes over it, `MIN` will be expanded
to:

~~~~C
      printf("%s%d\n", "Smallest number is : ", a < b ? a : b));
~~~~

## Using Macros to Define Functions

Another use case to using macros would be to construct redundant functions.
Maybe you won't see it in the exact same notion as the one bellow, but a good
chance you'll see something similar.

~~~~C
    #include <stdio.h>

    #define GENERIC_SUM(T) \
      T sum_ ## T (T A, T B) { \
        return A + B;   \
      }

    GENERIC_SUM(int);
    GENERIC_SUM(float);
    GENERIC_SUM(double);

    int main(void) {
      int    x = sum_int(1, 2);
      float  y = sum_float(12.32f, 32.11f);
      double z = sum_double(99.0123f, 312.123123f);
      return 0;
    }
~~~~

You could also do the same to define various classes in C++, but that should be
considered in special cases only - and if there are any.

## Hygiene Problems

In C, macros are a simple search and expand mechanism. Because of that we can do
interesting, almost hackish things as creating functions. But this is also a
disadvantage, as replaces might interfere with existing, sane, behavior. For
example the code below gives an example where things might go wrong:

~~~~C
    #include <stdio.h>

    #define BADMAC a += a;
    int main(void) {
      int a = 1, b = 2, c = 0;

      BADMAC;

      c = a + b;

      printf("I expected a + b = %d\n", 3);
      printf("But I actually got a + b = %d\n", c);
      return 0;
    }
~~~~

Output:

~~~~nocode
      I expected a + b = 3
      But I actually got a + b = 4
~~~~

This is a very simplified version of things going wrong with macros and hygiene
in C, from the following example [c-hyg-mac].

Some other languages take care of this issue with mechanisms totally transparent
to the progammer.

# References

- \[cxxfaq\] [http://www.parashift.com/c++-faq/][cxx-faq-link]
- \[c-hyg-mac\] [http://en.wikipedia.org/wiki/Hygienic\_macro#The\_hygiene\_problem][hyg-wiki-link]

[cxx-faq-link]: http://www.parashift.com/c++-faq/
[hyg-wiki-link]: http://en.wikipedia.org/wiki/Hygienic_macro#The_hygiene_problem
