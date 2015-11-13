class Shape
  def area
    raise NotImplementedError, "This needs implementation"
  end
end

class Circle < Shape
  def initialize(val); @radius = val end
  def area; @radius ** 2 * 3.142 end
end

class Square < Shape
  def initialize(val); @side = val end
  def area; @side ** 2 end
end

class Triangle
  def initialize(base, height); @b, @h = base, height end
  def area; @b * @h * 0.5 end
end

[Circle.new(1.2), Square.new(2.1), Triangle.new(1.0, 3.2)].each do |shape|
puts shape.area
end

# 4.52448
# 4.41
# 1.6
