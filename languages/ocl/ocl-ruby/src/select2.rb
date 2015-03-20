class Person
  def initialize(age)
    @age = age
  end

  def inspect
    "<Person aged #{@age}>"
  end
  attr_accessor :age
end

# Randomly generate 20 people with ages. This will give you an array of size 20,
# populated with Person objects, set with randomly generated ages.
people = ([Proc.new{Person.new(rand(18..90))}] * 20).map &:call

# The 20 randomly generated people
puts "All the people"
p people
puts

puts "People over the age of 80"
print "  "
p people.select{|e| e.age > 80}
puts

puts "People between the ages of 50 and 60 (inclusive)"
print "  "
p people.select{|e| e.age >= 50 && e.age <= 60}
puts

puts "People between 50, 60, and div by 2"
p people.select{|e| e.age >= 50 && e.age <= 60 && e.age % 2 == 0 }
puts


