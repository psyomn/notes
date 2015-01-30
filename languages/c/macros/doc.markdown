% Macros in the C Programming Language
% Simon Symeonidis

# Introduction

I aim to cover some basic things about macros, uses, and gotchas in this simple
writeup. I may give a good general advice about macros, but I am not a
professional in C. Some other resources might give better information and
you're encouraged to take a look [cxxfaq].

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
    #define begin {
    #define end }
    #define mod %
    #define eq ==

    int main() {

        for(x = 0; x < 10; ++x) begin
            if (x mod 2 eq 0) begin
            // ...
            end
        end

    }
~~~~

The above is legal. But it is not recommended to use for obvious reasons. If you
start defining too many things, maybe some definitions will start clashing with
other definitions you import.

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

~~~~

## Using Macros for Function Defs

You can also use macros to redefine functions that would otherwise waste time to
reimplement all the time.

# References

- \[cxxfaq\] [http://www.parashift.com/c++-faq/][cxx-faq-link]

[cxx-faq-link]: http://www.parashift.com/c++-faq/
