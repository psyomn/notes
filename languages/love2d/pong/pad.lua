Pad = {}
Pad.__index = Pad

function Pad:new(x, y, width, height)
   local p = {}
   setmetatable(p, Pad)
   p.x = x
   p.y = y
   p.width = width
   p.height = height
   p.vel = 200
   p.human = nil
   return p
end

function Pad:isHuman(choice)
   self.human = choice
end

function Pad:update(dt)
   if self.human == nil then
      -- do nothing
      return
   end

   if self.human then
      -- process keyboard
      if love.keyboard.isDown("up") then
         self.y = self.y - self.vel * dt
      end

      if love.keyboard.isDown("down") then
         self.y = self.y + self.vel * dt
      end
   else
      -- garbage ai here
      if ball:getY() > self.y then
         self.y = self.y + self.vel * dt
      else
         self.y = self.y - self.vel * dt
      end
   end
end

function Pad:draw()
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Pad:getX()
   return self.x
end

function Pad:getY()
   return self.y
end

function Pad:getHeight()
   return self.height
end

function Pad:getWidth()
   return self.width
end
