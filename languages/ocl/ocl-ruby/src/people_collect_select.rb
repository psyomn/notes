class Person
  def initialize(age); @age = age end
  attr_accessor :age
end

arr = [Person.new(10), Person.new(32), Person.new(33), Person.new(43)]

p arr.collect{|e| e.age}.select{|e| e % 2 == 0}
# output: [10, 32]
