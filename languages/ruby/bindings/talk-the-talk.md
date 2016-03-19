% Writing Bindings for Ruby
% psyomn

# Possible ways to write bindings
* via native C extensions (extconf/mkmf)
* *ffi*: https://github.com/ffi/ffi
* *rubyinline*: https://github.com/seattlerb/rubyinline

# Stuff to talk about

* Introduce extconf

* Other {c,ld}flags you can set for extconf

* Ruby/C types, and how they're represented (VALUEs, RVALUE?)

* Debugging, and checking for memory leaks

# Motivation

## Performance
* you might want to do serious number crunching in a c module

## Porting Existing Libraries

* Usually a more popular reason
* Better to use time tested and mature software
* But what if they're provided as compiled libraries?

<!--
  How do we do something simple?

  * How to make the makefile script
  * How to compile
  * How to run
-->

# Writing your first utility
* you need an extconf.rb
* require 'mkmf'
* What is mkmf?
* writing a simple png interface to check headers

~~~~ruby
    require 'mkmf'
    extension_name = 'example_b'
    dir_config(extension_name)
    create_makefile(extension_name)
~~~~

# Defining things in C

* Module definition in the C file
* Method definition in the C file
  * done via magic numbers
  * In the positives means number of args
  * -1
  * -2 means variadic

# Types from C to Ruby
* There exists predicates to check for types or,
* Another common pattern is to use a switch against object id type

<!--
  How do we do something a little more involved?

  * How do we link against the library?
  * What utilities from ruby.h may we use and pass back?
  * How are exceptions handled?
-->

# Bindings with filemagic

* What is inside the library?
* What does the gem do?
* https://github.com/blackwinter/ruby-filemagic/blob/master/ext/filemagic/filemagic.c

# Bindings with iplists
* https://github.com/tokenrove/normalize-iplist

# Other interesting readings
* Skylight.io: Yehuda Katz talks about using Rust with Ruby
  * http://blog.skylight.io/bending-the-curve-writing-safe-fast-native-gems-with-rust/

<!--
/usr/lib64/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in
`require':
/home/psyomn/programming/architecture-notes/languages/ruby/bindings/src/example_b.so: undefined symbol: Init_example_b -
/home/psyomn/programming/architecture-notes/languages/ruby/bindings/src/example_b.so
(LoadError)
  from /usr/lib64/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in 
  `require'
    from test.rb:2:in `<main>'
-->
