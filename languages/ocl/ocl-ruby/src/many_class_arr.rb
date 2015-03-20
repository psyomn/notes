class Vampire
end

class Person
end

class Cat
end

class Dog
end

vamp1 = Vampire.new
vamp2 = Vampire.new
vamp3 = Vampire.new

pers1 = Person.new
pers2 = Person.new
pers3 = Person.new

cat1 = Cat.new
cat2 = Cat.new

dog1 = Dog.new
dog2 = Dog.new

# An array that contains all the above
mixed_a = [
  vamp1, vamp2, vamp3, pers1,
  pers2, pers3, cat1, cat2,
  dog1, dog2]

# How many dogs exist in the array?
puts mixed_a.select{|e| e.class.name == "Dog"}.size

# How many dogs exist in the array?
puts mixed_a.select{|e| e.class.name == "Cat"}.size

# How many vamps exist in array?
puts mixed_a.select{|e| e.class.name == "Vampire"}.size

# How many people in array?
puts mixed_a.select{|e| e.class.name == "Person"}.size

# Output
# 2
# 2
# 3
# 3
