require 'net/http'
require 'nokogiri' # You need to have this gem

module XMLRetriever
  class Book
    attr_accessor :name, :author, :isbn, :price, :id, :is_recommended, :short_desc
  end

  def get_ids
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

  def get_book(id)
    uri = URI("http://localhost:3001/books/of/#{id}")
    response = Net::HTTP.get_response(uri)
    doc = Nokogiri::XML(response.body)
    book_xml = doc.at_xpath("//book")
    make_book(book_xml) # return this value
  end

  def make_book(xml)
    b = Book.new
    xml.children.each do |el|
      case el.name
      when 'id'
        el.children.first.text
      when 'isbn'
        el.children.first.text
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

  def get_books
    ids = get_ids
    books = Array.new
    ids.each do |id|
      books.push get_book(id)
    end
    books
  end
end

