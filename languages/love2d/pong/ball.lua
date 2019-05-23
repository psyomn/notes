require "init"

Ball = {}
Ball.__index = Ball

function Ball:new(x, y)
   local b
   b = {}
   setmetatable(b, Ball)

   direction = 1
   if math.random(1, 10) % 2 == 0 then
      direction = -1
   end

   b.x = x
   b.y = y
   b.width = 10
   b.height = 10
   b.vel_x = 200 * direction
   b.vel_y = 200 * direction

   return b
end

function Ball:update(dt)
   self.x = self.x + self.vel_x * dt
   self.y = self.y + self.vel_y * dt

   if self.x > windowWidth then
      if self.vel_x > 0 then
         self.vel_x = self.vel_x * -1
      end
   end

   if self.x < 0 then
      if self.vel_x < 0 then
         self.vel_x = self.vel_x * -1
      end
   end

   if self.y > windowHeight then
      if self.vel_y > 0 then
         self.vel_y = self.vel_y * -1
      end
   end

   if self.y < 0 then
      if self.vel_y < 0 then
         self.vel_y = self.vel_y * -1
      end
   end
end

function Ball:draw()
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

-- other must have getX, getY, getWidth, getHeight
function Ball:collidesWith(other)
   -- Intersection check between two rectangles
   -- can be done this way:
   --   Bx + Bw > Ax &&
   --   By + Bh > Ay &&
   --   Ax + Aw > Bx &&
   --   Ay + Ah > By;

   -- And translated to this:
   return other:getX() + other:getWidth() > self.x and
      other:getY() + other:getHeight() > self.y and
      self.x + self.width > other:getX() and
      self.y + self.height > other:getY()
end

function Ball:setVelRight()
   if self.vel_x < 0 then
      self.vel_x = self.vel_x * -1
   end
end

function Ball:setVelLeft()
   if self.vel_x > 0 then
      self.vel_x = self.vel_x * -1
   end
end

function Ball:getY()
   return self.y
end

function Ball:getX()
   return self.x
end

function Ball:getHeight()
   return self.height
end

function Ball:getWidth()
   return self.width
end
