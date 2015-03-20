class Vampire
  def hide_name
    @name.reverse.capitalize
  end
  attr_accessor :name
end

p Vampire.instance_methods - Object.instance_methods
