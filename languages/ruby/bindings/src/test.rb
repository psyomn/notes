# run with ruby -I. test.rb
require 'example_b'

class Person
  include ExampleB
end

p Person.new.ret_i
# p Person.new.ret_f

person = Person.new

["hello", 12.12, :hahaha, nil, [1,2,3], {a: :b}, Struct.new(:a, :b)].each do |el|
  p person.with_one_param(el)
end

p person.variadic(1)
p person.variadic(1, 2)
p person.variadic(1, 2, 3)
p person.variadic

def rbdjb2(str)
  hash = 5381

  str.chars.each do |c|
    hash = ((hash << 5) + hash) + c.ord % (2 ** 32)
  end

  hash
end


p person.djb2("hello world")
p rbdjb2("hello world")
