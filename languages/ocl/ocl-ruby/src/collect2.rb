class Person
  def initialize(age)
    @age = age
  end

  def age_rage
    case @age
    when 12     then "life is nice"
    when 13..34 then "im older and angry"
    when 35..50 then "mgr gr gr"
    else "I AM FURIOUS! WARGAGLBAGL!"
    end
  end

  attr_accessor :age
end

p1 = Person.new(12)
p2 = Person.new(32)
p3 = Person.new(42)
p4 = Person.new(74)

arr = [p1, p2, p3, p4]

puts "The collection of ages: "
p arr.collect{|e| e.age}
puts

puts "Anger depending on age"
p arr.collect{|e| e.age_rage}
puts

# The collection of ages:
# [12, 32, 42, 74]
#
# Anger depending on age
# ["life is nice", "im older and angry",
#  "mgr gr gr", "I AM FURIOUS! WARGAGLBAGL!"]

