% Notes about the Rust Compiler, Packages and Files
% Simon Symeonidis
% Fri Dec 12 17:09:46 EST 2014

# Notes about Rustlang

These notes are here to help me, and anyone else who's going into the source
code of the _actual compiler_. These are not notes of the programming language
at the user level.

## What I'm looking at

Currently looking at packages of interest that might provide ways to extract
ASTs from rust source code. The best lead to do this is to look into rustdoc and
see how it identifies different definitions in source code, and manipulates them
for API generation.

# Before Looking in the Source

It would be a good time to list the git submodules (separate projects) that this
project uses:

- jemalloc: a malloc library written by *J*ason *E*vans, that uses 'arenas' to
  allocate memory for multithreaded applications, which may increase performance
  and scalability. More info on that may be found here: \[jemalloc\].

- llvm: A collection of tools which greatly eases implementation of compilers.
  Due to the 'non-monolithic' architecture of llvm, the optimizer and back ends
  of the compiler should be easily reusable.

- compiler-rt: One of the libraries that is within the llvm project that
  provides some common runtime capabilities.

- hoedown: A markdown parser written in C. This particular submodule currently
  exists as a fork of the official hoedown repository, within the rustlang
  organization.

# Overall Layout

The following is not a one-to-one demonstration of the rust compiler layout. I'm
trying to separate things conceptually for a better understanding of what
exists in the `rustlang` repository. The figure of interest is Fig
\ref{fig:packages}.

![Overall Package Layout \label{fig:packages}](./fig/packages.png)

## src/README.md Layout file

For some reason, the layout file was deleted in commit [c93d47d][del-layout-commit].
It gave a nice overall idea about what each directory structure meant in the
rust pacakge.

[del-layout-commit]: https://github.com/rust-lang/rust/commit/c93d47d395d7490ed0d985ad205156119efd252d

We'll be covering everything that was in that file, but also update on the
information (some of it's contents were a little outdated - yet still very
helpful).

First we'll be taking a look at the conceptual groups. That is the packages in
the diagram that contain smaller components.

#### Rust Libraries

This contains a bunch of smaller libraries that are writen in Rust. These
libraries are either what is included in the runtime of the core language, and
other parts that the user of the language may use such as implementations of
hash maps, vectors, and more.

#### Compiler

Packages and files which contain specific structures and behavior that is
required in order to get a working compiler. For example ASTs, parsers, and type
checkers are grouped here. A rust interface with bindings to `LLVM` is also
found here.

#### Compiler.Testing

You may notice that there exists a conceptual package within compiler called
"Compiler Testing". That contains the packages which perform some sort of
testing for the compiler (ie, were functional tests, and regression tests and
more are found).

#### Util

Is a conceptual package that contains a bunch of rust implementations of tools
that are not completely related to anything else, but bring some helpful
features into play. Rustdoc is a documentation tool for Rust source code. The
package "libterm" is a wrapper for the "terminfo" library, which provides a
bunch of useful things to the compiler, such as colored output of error
messages. The package "librbml" is an acronym for "really bad markup language",
and from what I could understand from the source aims to be either replaced or
improved.

#### LLVM Components / 3rd party utils

Conceptually contains three packages: llvm, rt, compiler-rt

#### Memory

Conceptually contains the packages: jemalloc, liballoc, and libarena. The two
libraries liballoc, and libarena are written in Rust; jemalloc is a submodule,
written in C.

####

# References

* \[jemalloc\]: [http://people.freebsd.org/~jasone/jemalloc/bsdcan2006/jemalloc.pdf][jemalloc-paper]

[jemalloc-paper]: http://people.freebsd.org/~jasone/jemalloc/bsdcan2006/jemalloc.pdf
