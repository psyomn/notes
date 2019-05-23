Meatsicle = {}
Meatsicle.__index = Meatsicle

function Meatsicle:new(name, age)
   local o = {}
   setmetatable(o, Meatsicle)
   o.name = name
   o.age = age
   return o
end

function Meatsicle:getAge()
   return self.age
end

function Meatsicle:getName()
   return self.name
end
