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

function Bullet:collideWith(x, y, to_x, to_y)
   return ((self.x >= x && self.x <= to_x) ||
      (self.y >= y && self.y <= to_y)) ||
   ((self.to_x >= x && self.to_x <= to_x) ||
      (self.to_y >= y && self.to_y <= to_y))
end

function Bullet:shouldRemove()
   local niceness = 100

   return self.x > (love.graphics.getWidth() + niceness) ||
   self.y > (love.graphics.getHeight() + niceness) ||
   self.x < -niceness ||
   self.y < -niceness
end
