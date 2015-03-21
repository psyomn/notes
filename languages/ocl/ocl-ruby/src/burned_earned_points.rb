class Transaction
  def initialize(points)
    @points = points
  end
  attr_accessor :points
end

class Earning < Transaction
  def initialize(points)
    super(points)
  end
end

class Burning < Transaction
  def initialize(points)
    super(points)
  end
end

# I am extending the core library this way, so that Array has a method called
# 'sum' (so that it looks more familiar to OCL). In other ruby applications,
# this sort of thing is usually discouraged. If you need to do something like
# this in Ruby, you should look into Refinements.
class Array
  def sum
    self.inject{|sum,e| sum + e}
  end
end

t_arr = [Earning.new(100), Earning.new(400), Earning.new(200),
         Burning.new(200), Burning.new(100), Burning.new(300),
         Burning.new(100), Earning.new(500), Earning.new(100)]

puts "How many transactions do we have?"
puts t_arr.size
puts

puts "Are they all kinds of transaction?"
puts t_arr.select{|e| e.kind_of? Transaction}.size == t_arr.size
puts

puts "How many transactions are earning?"
puts t_arr.select{|e| e.class.name == "Earning"}.size
puts

puts "How many transactions are burning?"
puts t_arr.select{|e| e.class.name == "Burning"}.size
puts

puts "Total Earning:"
puts t_arr.select{|e| e.kind_of? Earning}.collect{|e| e.points}.sum
puts

puts "Total Burning"
puts t_arr.select{|e| e.kind_of? Burning}.collect{|e| e.points}.sum
puts

puts "Absolute Magnitude"
puts t_arr.collect{|e| e.points}.sum

# How many transactions do we have?
# 9
#
# Are they all kinds of transaction?
# true
#
# How many transactions are earning?
# 5
#
# How many transactions are burning?
# 4
#
# Total Earning:
# 1300
#
# Total Burning
# 700
#
# Absolute Magnitude
# 2000
