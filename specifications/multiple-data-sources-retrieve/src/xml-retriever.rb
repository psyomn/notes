require 'net/http'
require 'nokogiri' # You need to have this gem

class Book
  attr_accessor :name, :author, :isbn, :price, :id, :is_recommended, :short_desc
end

def get_ids
  uri      = URI('http://localhost:3001/books/current')
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

def get_book
end

def get_all_books
end

def get_books
  books    = Array.new
  JSON[response.body].each do |book_js|
    b = Book.new
    b.author = book_js["author"]
    b.name = book_js["name"]
    b.isbn = book_js["isbn"]
    b.price = book_js["price"]
    b.id = book_js["id"]
    books.push b
  end
books end

p get_ids
