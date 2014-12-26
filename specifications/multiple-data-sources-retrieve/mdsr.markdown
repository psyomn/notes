% Multiple Interfaces to non standardized data sources
% Simon Symeonidis

# Multiple Data Source Retrieve

This is just a few notes that I wanted to put down and improve along the way. My
main question is what do you do when you have multiple sources, sharing similar
data, but in conflicting formats, or have different steps in order to retrieve
the data with.

How should these concerns be separated in such a fashion that we get a coherent
architecture, which can be extended without aging poses a somewhat interesting
challenge.

# Multiple Sources

You might have a concept that you want to portray universally, on your local
application. This concept will exist physically on your machine once you have
retrieved it from any source that may provide it. You need to think about a
bunch of things however. What if the sources that provide data, have the same
data on each respective end? What if they provide the same data, with small
differences? Which one would be preferred? Should there be some sort of logging
to keep track of where some data was retrieved in case of conflicts in the
future?

Another consideration is whether to have the implementation in a polyglot
setting: if the services provided by different sources, and their services are
published, there's a good chance different implementation in different languages
may have already been written.

Finally one should also consider how all this distributed information may be
unified into a single point. For example, if we're writing a tool that wants to
query different sources seemlessly for particular data, and have a nice overall
design, we might want some sort of front end to all of these 'back ends'.

# Unified API

The front end to all the plugins, or scattered implementations that may retrieve
data from the given sources. It would be nice to have the indirection happen
here - make the user deal with the interface, but hide what is actually
happening in the background (ie: heuristics to choose a particular source or any
other back end dealing goes here). It would be worthwhile to note that we want
the ability to choose a particular source in case things are not working
properly - ie override automatic behavior if need be.

