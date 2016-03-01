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
