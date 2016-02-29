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

* Better to use time tested and mature software

* But what if they're provided as compiled libraries?

# Startup; what you'll need

# Writing your first utility

# Bindings with iplists

# Other interesting readings

* Skylight.io: Yehuda Katz talks about using Rust with Ruby
