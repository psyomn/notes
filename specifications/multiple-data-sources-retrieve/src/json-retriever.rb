require 'net/http'
require 'json'

module JSONRetriever
  class Book
    attr_accessor :name, :author, :isbn, :price, :id
  end

  def get_books
    uri      = URI('http://localhost:3000/books/all')
    response = Net::HTTP.get_response(uri)
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
    books
  end
end
