% Notes about the Rust 0.13 Compiler, Packages and Files (Draft)
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

## Glossary

Crates are libraries. And just like libraries, we can have executable crates, or
crates which were created to provide redundant functionalities, just like
libraries.

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

* libcollections: is a collection of data structures. Currently in this crate,
  there exists set, and map implemented with a tweaked btree [^btreenote], as
  well as alternate implementations with tries and regular trees. Other
  components such as `str`, `String`, and `vec` may be found here.

* libcore: contains some core macros, cell, iterators, option (the monad), and
  more. This crate is stressed not to be included and is not meant to be
  included by users manually. The standard library exposes the functionalities
  required for programs instead.

* liblog: exists for simple logging, provided by the macros `debug`, `info`,
  `warning`, and `error`.

* librand: is a random number generator implementation that provides different
  models to be used by the user of this library. Different algorithms are
  provided such as the `chacha20`, and `isaac` algorithms.

* libserialize: provides a serialize methods to export to different formats such
  as JSON, base64 (vector of u8 bytes to base64 string).

* liblibc: bindings for the C standard library. This is platform specific, so on
  linux this is targeted to glibc.

* libregex: a implementation of Regular Expressions in Rust. Heavilly based on
  RE2 [^RE2].

* libtime: currently (0.13) deprecated, and use of an alternate time crate is
  suggested: [http://github.com/rust-lang/time](http://github.com/rust-lang/time).

* libunicode: unicode supporting functions for unicode strings.

[^btreenote]: the b-tree is made to use arrays for a bunch of elements per
memory allocation in order to improve performance. More info could be found
here: [https://github.com/rust-lang/rust/blob/master/src/libcollections/btree/map.rs#L36](https://github.com/rust-lang/rust/blob/master/src/libcollections/btree/map.rs#L36)

[^RE2]: https://code.google.com/p/re2/

#### Compiler

Packages and files which contain specific structures and behavior that is
required in order to get a working compiler. For example ASTs, parsers, and type
checkers are grouped here. A rust interface with bindings to `LLVM` is also
found here.

* librustc: Contains all the compiler specific implementations and definitions.
  This is also where the implementation of each phase may be found. This crate
  depends on four crates: libsyntax, librustc\_back, and librustc\_trans. This
  crate (librustc) seems to bring everything together in a higher level context.

* librustc\_driver: this contains basic implementation of a driver for the rust
  compiler. In other words it includes the components it needs from `librustc`
  and acts as a mediator. I'm guessing this was done to hide things from the
  user of the compiler. According to \[rust-tom-lee\] where rust was still
  version 0.10, it looks like the driver was included in the librustc library at
  first, and later on moved out to its own module. Any information that one may
  want to extrat about the way passes are done in rust, for compilation may be
  found here on the highest level - a good starting point to understand the way
  they have organized the compilation procedure.

* libsyntax: things that have to do purely with syntax and some semantics to an
  extent. If you want to extract ASTs from source code and write tools to
  generate metrics for example, this crate is what you should look at.

* librustc\_trans: last phase of compilation process. This is what converts the
  rust code to the LLVM assembly intermediate representation (IR).

* librustc\_back: aiming for specific llvm exports. For example you could find
  support files for different platforms in here (Android, MIPs, and other
  architectures).

* librustc\_tycheck: type checker for each expression, resolving methods and
  traits, and checks that most type rules are met.

* librustc\_llvm: rust bindings to the llvm library.

* librustc\_borrowck: the borrow checker has been separated from some of the
  source of the compiler, to a separate crate.

* libbacktrace: a backtrace library, whose source is in C. This is _probably_
  used in order to produce backtraces in Rust programs.

* grammar: looks like a testing utility, to check against a specification of
  Rust grammar written in ANTLR grammar syntax (see \[antlr\]), and the actual
  Rust implementation. One may invoke the grammar tests with the make target
  `check-syntax` in the Rust root folder.

* rustllvm: support code for LLVM, written by the Rust developers to help in
  development.

* librustrt: various platform specific things for the Rust runtime (eg: stack
  management, threads, etc go here).

#### Compiler.Testing

You may notice that there exists a conceptual package within compiler called
"Compiler Testing". That contains the packages which perform some sort of
testing for the compiler (ie, were functional tests, and regression tests and
more are found). Some of the files will have github issue ids linking back to
bugs found in the compiler.

#### Util

Is a conceptual package that contains a bunch of rust implementations of tools
that are not completely related to anything else, but bring some helpful
features into play. Rustdoc is a documentation tool for Rust source code. The
package "libterm" is a wrapper for the "terminfo" library, which provides a
bunch of useful things to the compiler, such as colored output of error
messages. The package "librbml" is an acronym for "really bad markup language",
and from what I could understand from the source aims to be either replaced or
improved in the future.

#### LLVM Components / 3rd party utils

Conceptually contains three packages: llvm, rt, compiler-rt. Compiler-rt and
llvm are the packages provided from [llvm.org](http://llvm.org). The package
'rt' contains some includes of other headers to interface to other projects such
as miniz (a compression library), hoedown which was previously mentioned, and
valgrind. There exists some LLVM ASM code as well. These are packages probably
required in the runtime of Rust.

#### Memory

Conceptually contains the packages: jemalloc, liballoc, and libarena. The two
libraries liballoc, and libarena are written in Rust; jemalloc is a submodule,
written in C.

#### Lib Wrappers

This contains a simple wrapper around a C library. The library libflate is a
wrapper around `miniz` (zlib compression). libgraphiz is not a wrapper, but a
simple implementation that helps exporting dot graphs programmatically - ie
provide a bunch of nodes with data, connect them, and the program you coded will
export the textual representation.

# References

* \[jemalloc\]: [http://people.freebsd.org/~jasone/jemalloc/bsdcan2006/jemalloc.pdf][jemalloc-paper]

* \[rust-tom-lee\]: [http://tomlee.co/2014/04/03/a-more-detailed-tour-of-the-rust-compiler/][rust-tom-lee-link]

* \[antlr\]: [http://antlr.org][antlr-link]

[jemalloc-paper]: http://people.freebsd.org/~jasone/jemalloc/bsdcan2006/jemalloc.pdf
[rust-tom-lee-link]: http://tomlee.co/2014/04/03/a-more-detailed-tour-of-the-rust-compiler/
[antlr-link]: http://antlr.org

