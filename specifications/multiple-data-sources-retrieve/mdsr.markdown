% Multiple Interfaces to non standardized data sources
% Simon Symeonidis
% Sat Dec 27 23:06:32 EST 2014

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
may have already been written. Then linking up different parts would either
consist of including the different implementations via language imports, using
bindings to interface to different languages (eg: C to Ruby), or using socket
communications, and provide the services as individual running processes.

Finally one should also consider how all this distributed information may be
unified into a single point. For example, if we're writing a tool that wants to
query different sources seemlessly for particular data, and have a nice overall
design, we might want some sort of front end to all of these 'back ends'. So
there should be a package containing all of these individual implementations,
and another package orchestrating the fetches. In Figure \ref{fig:org} the
backend is the 'Foreign Data Sources' package, and the orchestrator is the
'Mediator Layer'.

# Unified API

The front end to all the plugins, or scattered implementations that may retrieve
data from the given sources. It would be nice to have the indirection happen
here - make the user deal with the interface, but hide what is actually
happening in the background (ie: heuristics to choose a particular source or any
other back end dealing goes here). It would be worthwhile to note that we want
the ability to choose a particular source in case things are not working
properly - ie override automatic behavior if need be.

Usually what you want to apply here is the Adapter pattern for each
implementation [adapter]. This is portrayed in the 'mediator' layer in Figure
\ref{fig:org}.

One should give a good thought on where the implementations store the downloaded
data - you might choose to go from the interface, to the mediator and fetch each
implementation's retrieved data, or make the mediator move all the data to a
single, specific path. The latter sounds like a much easier approach.

# Thin Client Interface

Finally it would be the most convenient to have an interface, that communicates
with the Unified API. This would delegate all the fetching logic into that
particular section, leaving the interface, as well as the smaller fetching
components completely oblivious to this logic. This is portrayed in the
'frontend' package in Figure \ref{fig:org}.

The CLI part, or the main interface should have some sort of registry to keep
track of anything that is retrieved. For example if we have data A, B, C, and D
we invoke a retrieve request, we could have things go wrong. Maybe C will
timeout. Next time we re-invoke the data retrieve, it would be favorable for the
application to keep track of what is already downloaded, and issue a warning to
the user. All of this could be stored in a flat file database (so for example,
sqlite could be a good candidate). A text file could probably work well as long
as the list didn't get too big.

Last, there might be filesystem capabilities the the interface might need to
take advantage - are we caching all the restored data for future use?

![Overall Organization\label{fig:org}](fig/mainfig.png)

# Practical Example

Let's write a simple example demonstrating the above. Let's say we have a two
simple servers that store books. There exists two ways to retrieve information
from these two servers. One way is to perform a JSON request over HTTP, and the
other is to perform an XML request over HTTP.

# References

- \[adapter\] Design Patterns: Elements of Reusable Object-Oriented Software,
  Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides,
  [http://goo.gl/xsxTh5][oop-link]

[oop-link]: http://goo.gl/xsxTh5
