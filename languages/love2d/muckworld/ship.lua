Ship = {}
Ship.__index = Ship

function Ship:new(x, y)
   local ship = {}
   setmetatable(ship,Ship)

   ship.img = love.graphics.newImage("img/Pirate_Ship.png")

   ship.x = x
   ship.y = y
   ship.x_vel = 0
   ship.y_vel = 0

   ship.std_vel = 200
   ship.visc = 600
   return ship
end

function Ship:update(dt)
   if love.keyboard.isDown("a") then
      self.x_vel = -self.std_vel
   end

   if love.keyboard.isDown("d") then
      self.x_vel = self.std_vel
   end

   if love.keyboard.isDown("w") then
      self.y_vel = -self.std_vel
   end

   if love.keyboard.isDown("s") then
      self.y_vel = self.std_vel
   end

   if love.keyboard.isDown("space") then
      -- TODO: pew pew placeholder
   end

   if self.y_vel ~= 0 then
      if self.y_vel > 0 then
         self.y_vel = self.y_vel - self.visc * dt
      end

      if self.y_vel < 0 then
         self.y_vel = self.y_vel + self.visc * dt
      end
   end

   -- slidy slide
   if self.x_vel ~= 0 then
      if self.x_vel > 0 then
        self.x_vel = self.x_vel - self.visc * dt
      end

      if self.x_vel < 0 then
         self.x_vel = self.x_vel + self.visc * dt
      end

      self.x = self.x + self.x_vel * dt
      self.y = self.y + self.y_vel * dt
   end
end

function Ship:draw()
   love.graphics.draw(self.img, self.x, self.y)
end
