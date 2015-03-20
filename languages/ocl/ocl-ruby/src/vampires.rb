class Vampire
  def hide_name
    @name.reverse.capitalize
  end
  attr_accessor :name
end

drac = Vampire.new
drac.name = "Dracula"

puts drac.name
puts drac.hide_name
