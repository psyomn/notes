% Rust Macros: A simple tutorial
% Simon Symeonidis

# Introduction

These are notes. They will be messy. Maybe I will clean this up one day.

# First things first

Macros in Rust are a little different from the ones in C. In C it was purely
messing with the preprocessor. You can substitute pretty much anything when you
expand the macros. You can even redefine curly brackets to 'begin' and 'end' so
that you have a weird, questionably hybrid language.

Macros in Rust may take in arguments, but these arguments must be typed in a
sense. For example, you must declare an identity if you want to pass in an
identifier (eg: int x) using 'ident', or for another example, denote that you
want to pass in an expression, if you want to pass in a language construct - you
can do that with 'expr'.
