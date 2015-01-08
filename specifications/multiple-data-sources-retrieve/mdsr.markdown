% Standardizing Multiple Data Sources via Indirect API
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

There is a problem: the JSON version of the server is programmed well, and we
can retrieve all the books with a simple request. However on the other hand the
XML server has a two step process to get all the books. The first request
retrieves all the _ids_ of the books, and then we request all the details of the
books by providing the required _ids_.

I have programmed two simple applications that may be used for this example:

- [https://github.com/psyomn/rails-notes/tree/master/book-servers/books-json][books-json-ln]
- [https://github.com/psyomn/rails-notes/tree/master/book-servers/books-xml][books-xml-ln]

[books-json-ln]: https://github.com/psyomn/rails-notes/tree/master/book-servers/books-json
[books-xml-ln]: https://github.com/psyomn/rails-notes/tree/master/book-servers/books-xml

So in the JSON implementation, we only have one URI we need in order to retrieve
all the information. When we visit:
[http://localhost:3000/books/all](http://localhost:3000/books/all), we get all
the books in json format:

~~~~json
    [
    {"id":1,
      "name":"The amazing story of Potato",
      "author":"Potatotron",
      "isbn":"11831POTATO1231",
      "price":121.12,
      "created_at":"2015-01-02T03:40:22.698Z",
      "updated_at":"2015-01-02T03:40:22.698Z"},

    {"id":2,
     "name":"The not so amazing adventures of superdull",
     "author":"Boring Dude",
     "isbn":"123112BORE12",
     "price":55.5,
     "created_at":"2015-01-02T03:40:22.845Z",
     "updated_at":"2015-01-02T03:40:22.845Z"},

    {"id":3,"name":"Bookface the Bookeater",
     "author":"My face is a book",
     "isbn":"111BOOK!111",
     "price":null,
     "created_at":"2015-01-02T03:40:22.978Z",
     "updated_at":"2015-01-02T03:40:22.978Z"}
    ]
~~~~

Now on the second server, we would have a two phase fetch. First we ask for the
available _ids_:

~~~~xml
    <fixnums type="array">
        <fixnum type="integer">1</fixnum>
        <fixnum type="integer">2</fixnum>
        <fixnum type="integer">3</fixnum>
    </fixnums>
~~~~
We get the above by requesting the URI: [http://localhost:3000/books/current](http://localhost:3000/books/current).
We know that we have the following as ids: [1,2,3]. The other piece of
information is that we have a URI for each individual book. The URI is
[http://localhost:3000/books/of/1](http://localhost:3000/books/of/1). The last
part in the URI is the _id_ of the book. We would request this URI with all the
given _ids_ from the first URI.

~~~~xml
    <book>
        <id type="integer">1</id>
        <name>The biography of someone we do not care about</name>
        <author>Someone Potato</author>
        <isbn>123103283IIA1298</isbn>
        <is-recommended type="boolean">true</is-recommended>
        <price type="integer">123</price>
        <short-desc>
          This is a book that is recommended by many gentlemen and scholars
        </short-desc>
        <created-at type="dateTime">2015-01-02T04:22:17Z</created-at>
        <updated-at type="dateTime">2015-01-02T04:22:17Z</updated-at>
    </book>
~~~~

And another request for the next _id_ (2):

~~~~xml
     <book>
         <id type="integer">2</id>
         <name>The answers to all problems volume 13</name>
         <author>Martin Ni</author>
         <isbn>1231MARTINNI12312</isbn>
         <is-recommended type="boolean">false</is-recommended>
         <price type="integer">55</price>
         <short-desc>
           Any questions you have ever had about the universe are answered here
         </short-desc>
         <created-at type="dateTime">2015-01-02T04:22:17Z</created-at>
         <updated-at type="dateTime">2015-01-02T04:22:17Z</updated-at>
     </book>
~~~~

Note: each server was started and stopped on its own (notice that both use
3000). Later on we set the json server on port 3000, and the xml server on port
3001.

## Defining the Retrievers as Modules

Since we want obliviousness from all the different components in this software,
it would be easier, and best to have each retriever as a smaller sub-project,
which has its own environment. For example, if we were developing on `Ruby`,
then it would be convenient to implement each retriever as a `Gem`. If we were
working with `Python`, then we would use python packages to separate each
implementation. For other languages such as C, then it would be wise to compile
to a library that would be linked against in the future.

Having everything as a separate module can help everythign work in its own way
without having the programmer care for side effects. For example if a module is
caching retrieved data, and hiding that this is happening with different calls
to different methods, we wouldn't be actively dealing with this (hopefully, if a
good interface to the module is given).

For this particular example however we will be using simple files which should
be thought of as modules - though not really complex ones in our case.

First the implementation of the JSON retriever (NB: port 3000):

~~~~ruby
    require 'net/http'
    require 'json'

    module JSONRetriever
      class Book
        attr_accessor :name, :author, :isbn, :price, :id
      end

      def self.get_books
        uri      = URI('http://localhost:3000/books/all')
        response = Net::HTTP.get_response(uri)
        books    = Array.new
        JSON[response.body].each do |book_js|
          b = JSONRetriever::Book.new
          b.author = book_js["author"]
          b.name = book_js["name"]
          b.isbn = book_js["isbn"]
          b.price = book_js["price"]
          b.id = book_js["id"]
          books.push b
        end
        books
      end
    end
~~~~

Next, we implement the XML retriever (NB: port 3001):

~~~~ruby
    require 'net/http'
    require 'nokogiri' # You need to have this gem

    module XMLRetriever
      class Book
        attr_accessor :name, :author, :isbn, :price, :id, :is_recommended, :short_desc
      end

      def self.get_ids
        uri = URI('http://localhost:3001/books/current')
        response = Net::HTTP.get_response(uri)
        doc = Nokogiri::XML(response.body)
        fixnums = doc.at_xpath("//fixnums")
        ids = Array.new
        fixnums.children.each do |fn|
          if fn.name == 'fixnum'
            ids.push fn.text.to_i
          end
        end
      ids end

      def self.get_book(id)
        uri = URI("http://localhost:3001/books/of/#{id}")
        response = Net::HTTP.get_response(uri)
        doc = Nokogiri::XML(response.body)
        book_xml = doc.at_xpath("//book")
        make_book(book_xml) # return this value
      end

      def self.make_book(xml)
        b = XMLRetriever::Book.new
        xml.children.each do |el|
          case el.name
          when 'id'
            b.id = el.children.first.text
          when 'isbn'
            b.isbn = el.children.first.text
          when 'name'
            b.name = el.children.first.text
          when 'price'
            b.price = el.children.first.text.to_f
          when 'is-recommended'
            b.is_recommended = el.children.first.text == 'true'
          when 'author'
            b.author = el.children.first.text
          when 'short-desc'
            b.short_desc = el.children.first.text
          end
        end
        b
      end

      def self.get_books
        ids = self.get_ids
        books = Array.new
        ids.each do |id|
          books.push get_book(id)
        end
        books
      end
    end
~~~~

Both show quite a difference in the way the implementation is required to be
done. But in the end, both retrieve a book object, but with differing amount of
member variables. This difference can be sorted out later in the mediator layer.

Finally, the part that remains is defining the mediator layer. The mediator will
interface to both retrievers and standardize whatever domain object we need, or
other logic. You can see this being done within the mediator module declaration,
when defining `Mediator::Book`. This could also be implemented as an adapter
\[adapter\].

~~~~ruby
    require_relative 'json-retriever'
    require_relative 'xml-retriever'

    module Mediator
      class Book
        # This is the fields from the XML retriever. However the JSON implementation
        # does not have all this information. For other implementations you might
        # want a compromise. For example you might want to keep short_desc, and null
        # it for whatever is found from the json implementation.
        #
        # attr_accessor :name, :author, :isbn, :price, :id, :is_recommended, :short_desc

        attr_accessor :name, :author, :isbn, :price, :id

        def to_s
          "Id     : #{@id}#{$/}"\
          "Name   : #{@name}#{$/}"\
          "Author : #{@author}#{$/}"\
          "ISBN   : #{@isbn}#{$/}"\
          "Price  : #{@price}#{$/}"
        end
      end

      def get_books_from_all_sources
        xml_books  = XMLRetriever::get_books
        json_books = JSONRetriever::get_books
        final_books = Array.new

        xml_books.each do |book|
          b = Mediator::Book.new
          b.name = book.name
          b.author = book.author
          b.isbn = book.isbn
          b.price = book.price
          b.id = book.id
          final_books.push b
        end

        json_books.each do |book|
          b = Mediator::Book.new
          b.name = book.name
          b.author = book.author
          b.isbn = book.isbn
          b.price = book.price
          b.id = book.id
          final_books.push b
        end
        final_books
      end
    end

    include Mediator

    get_books_from_all_sources.each do |book|
      puts book
      puts
    end
~~~~

The last part one should note in the above source code is the function calling
to get all the books, and where it prints them. This is basically a very simple
UI part that is merged with the mediator layer. In much more complex systems you
would include the mediator in the UI layer, and go on from there, implementing
anything else that might be required in the presentation layer.

Here is some sample output. This is information retrieved by both servers:

~~~~nocode
    Id     : 1
    Name   : The amazing story of Potato
    Author : Potatotron
    ISBN   : 11831POTATO1231
    Price  : 121.12

    Id     : 2
    Name   : The not so amazing adventures of superdull
    Author : Boring Dude
    ISBN   : 123112BORE12
    Price  : 55.5

    Id     : 3
    Name   : Bookface the Bookeater
    Author : My face is a book
    ISBN   : 111BOOK!111
    Price  :

    Id     : 1
    Name   : The amazing story of Potato
    Author : Potatotron
    ISBN   : 11831POTATO1231
    Price  : 121.12

    Id     : 2
    Name   : The not so amazing adventures of superdull
    Author : Boring Dude
    ISBN   : 123112BORE12
    Price  : 55.5

    Id     : 3
    Name   : Bookface the Bookeater
    Author : My face is a book
    ISBN   : 111BOOK!111
    Price  :
~~~~

# References

- \[adapter\] Design Patterns: Elements of Reusable Object-Oriented Software,
  Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides,
  [http://goo.gl/xsxTh5][oop-link]

[oop-link]: http://goo.gl/xsxTh5
