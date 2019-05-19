Obstacle = {}
Obstacle.__index = Obstacle

local id = 0

function Obstacle:new(img, x, y)
   local obs = {}
   setmetatable(obs,Obstacle)

   obs.img = img
   obs.x = x
   obs.y = y
   obs.x_vel = 0
   obs.y_vel = 0
   obs.id = id

   id = id + 1

   return obs
end

function Obstacle:makeSunkenTruck(x, y)
   img = love.graphics.newImage("img/sunken_truck.png")
   return Obstacle:new(img, x, y)
end

function Obstacle:makeLamp(x, y)
   img = love.graphics.newImage("img/64x32_Objects_to_put_in_Sludge.png")
   return Obstacle:new(img, x, y)
end

function Obstacle:setVelocity(x, y)
   self.x_vel = x
   self.y_vel = y
end

function Obstacle:update(dt)
   self.x = self.x + self.x_vel * dt
   self.y = self.y + self.y_vel * dt
end

function Obstacle:draw()
   love.graphics.draw(self.img, self.x, self.y)
end

function Obstacle:getId()
   return self.id
end

function Obstacle:print()
   print("obstacle", self)
   print("img", self.img)
   print("x", self.x)
   print("y", self.y)
   print("===================")
end

function Obstacle:isExpired(maxX, maxY, minX, minY)
   -- this is for checking if it's outside of the window
   -- quite a bit, so we can get rid of the garbage collector
   if self.x > maxX then return true end
   if self.y > maxY then return true end
   if self.x < minX then return true end
   if self.y < minY then return true end
end

function Obstacle:getX()
   return self.x
end

function Obstacle:getY()
   return self.y
end
