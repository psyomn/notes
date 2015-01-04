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
    include XMLRetriever
    include JSONRetriever
    xml_books  = XMLRetriever.get_books
    json_books = JSONRetriever.get_books
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
