Ship = {}
Ship.__index = Ship

function Ship:new(x, y)
   local ship = {}
   setmetatable(ship,Ship)

   self.img = love.graphics.newImage("img/Pirate_Ship.png")

   self.x = x
   self.y = y
   self.x_vel = 0
   self.y_vel = 0

   self.std_vel = 300
   self.visc = -500
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

   if self.x_vel ~= 0 then
      self.x = self.x + self.x_vel * dt
      self.x_vel = self.x_vel - self.visc
   end

   if self.y_vel ~= 0 then
      self.y = self.y + self.y_vel * dt
      self.y_vel = self.y_vel - self.visc
   end

   if self.y_vel < 0 then
      self.y_vel = 0
   end

   if self.x_vel < 0 then
      self.X_vel = 0
   end
end

function Ship:draw()
   love.graphics.draw(self.img, self.x, self.y)
end
