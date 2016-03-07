% Writing Bindings for Ruby
% psyomn

# Possible ways to write bindings

* via native C extensions (extconf/mkmf)

* *ffi*: https://github.com/ffi/ffi

* *rubyinline*: https://github.com/seattlerb/rubyinline

# Mission

* Introduce extconf

* Other {c,ld}flags you can set for extconf

* Ruby/C types, and how they're represented (VALUEs, RVALUE?)

* Debugging, and checking for memory leaks

# Motivation

## Performance

* djb is a ... simple hashing algorithm
* Ockham's razor: djb in C vs Ruby

## Porting Existing Libraries

* Usually a more popular reason
* Better to use time tested and mature software
* But what if they're provided as compiled libraries?

# Writing your first utility

* you need an extconf.rb
* require 'mkmf'
* What is mkmf?

~~~~ruby
    require 'mkmf'
    extension_name = 'example_b'
    dir_config(extension_name)
    create_makefile(extension_name)
~~~~

# Bindings with filemagic

* What is inside the library?

* What does the gem do?

# Bindings with iplists

# Other interesting readings

* Skylight.io: Yehuda Katz talks about using Rust with Ruby

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
