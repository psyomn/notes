class Shape
  def initialize(type, val)
    @type = type 
    @val  = val end
  def area
    case @type
    when :triangle then @val[0] * @val[1] * 1/2.0
    when :circle   then 3.142 * (@val ** 2)
    when :square   then @val ** 2 
    else raise "wrong discriminator" end
  end
end

triangle = Shape.new(:triangle, [1.0, 2.0])
circle   = Shape.new(:circle,   2.0)
square   = Shape.new(:square,   2.0)

[triangle, circle, square].each do |shape|
  puts shape.area
end
