Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y, x_vel, y_vel)
   local bull = {}
   setmetatable(bull, Bullet)

   bull.img = love.graphics.newImage("img/Cannonball.png")
   bull.r = 0

   bull.x = x
   bull.y = y
   bull.to_x = bull.img:getWidth()
   bull.to_y = bull.img:getHeight()

   bull.x_vel = x_vel
   bull.y_vel = y_vel
   return bull
end

function Bullet:update(dt)
   self.x = self.x + self.x_vel * dt
   self.y = self.y + self.y_vel * dt
end

function Bullet:draw()
   love.graphics.draw(self.img, self.x, self.y, self.r)
end

function Bullet:collidesWith(x, y, to_x, to_y)
   return self.x < x+to_x and
      to_x < self.x + self.to_x and
      self.y < y+to_y and
      to_y < self.y + self.to_y
end

function Bullet:shouldRemove()
   local niceness = 100

   return self.x > (love.graphics.getWidth() + niceness) or
      self.y > (love.graphics.getHeight() + niceness) or
      self.x < -niceness or
      self.y < -niceness
end

function Bullet:getX()
   return self.x
end

function Bullet:getY()
   return self.y
end

function Bullet:getToX()
   return self.to_x
end

function Bullet:getToY()
   return self.to_y
end

function Bullet:isExpired()
   -- this is for checking if it's outside of the window
   -- quite a bit, so we can get rid of the garbage collector
   if self.x > maxX then return true end
   if self.y > maxY then return true end
   if self.x < minX then return true end
   if self.y < minY then return true end
end
