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
