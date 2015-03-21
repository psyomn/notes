# Add the exists method
class Array
  def exists(&block)
    self.collect{|e| block.call(e)}.inject{|sum,e| sum || e}
  end
end

class Person
end

class Dog
end

class Cat
end

class Ferret
end

# there exists at least one ferret in the collection

arr = [Person.new, Person.new, Dog.new, Cat.new, Ferret.new,
       Ferret.new]

p arr.exists{|e| e.kind_of? Ferret}

arr = [Cat.new, Cat.new]

p arr.exists{|e| e.kind_of? Ferret}

# output
#   true
#   false
