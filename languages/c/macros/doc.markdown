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

The above is legal. But it is not recommended to use.

# References

- \[cxxfaq\] [http://www.parashift.com/c++-faq/][cxx-faq-link]

[cxx-faq-link]: http://www.parashift.com/c++-faq/
