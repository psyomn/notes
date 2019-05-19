require 'bullet'

EnemyShip = {}
EnemyShip.__index = EnemyShip

function EnemyShip:new(x, y, x_vel, y_vel)
   local enemy_ship = {}
   setmetatable(enemy_ship, EnemyShip)

   if math.random(1, 10) % 2 == 0 then
      enemy_ship.img = love.graphics.newImage("img/HutShip.png")
   else
      enemy_ship.img = love.graphics.newImage("img/Big_Cargo_Ship.png")
   end
   enemy_ship.counter = 0.0
   enemy_ship.x = x
   enemy_ship.y = y
   enemy_ship.to_x = enemy_ship.img:getWidth()
   enemy_ship.to_y = enemy_ship.img:getHeight()
   enemy_ship.x_vel = x_vel
   enemy_ship.y_vel = y_vel
   enemy_ship.parent = nil
   return enemy_ship
end

function EnemyShip:update(dt)
   self.x = self.x + self.x_vel * dt
   self.y = self.y + self.y_vel * dt

   self.counter = self.counter + dt

   if self.counter < 1.0 then
      return
   end

   self.counter = 0.0

   local shootingType = math.random(1, 100)

   if shootingType >= 95 then
      -- shotgun
   elseif shootingType >= 50 then
      -- normal shot
      table.insert(self.parent.items,
                   Bullet:new(self.x, self.y,
                              ship.x - self.x, ship.y - self.y))
   end
end

function EnemyShip:draw()
   love.graphics.draw(self.img, self.x, self.y)
end

function EnemyShip:isExpired(maxX, maxY, minX, minY)
   -- this is for checking if it's outside of the window
   -- quite a bit, so we can get rid of the garbage collector
   if self.x > maxX then return true end
   if self.y > maxY then return true end
   if self.x < minX then return true end
   if self.y < minY then return true end
end

function EnemyShip:setVelocity(x_vel, y_vel)
   self.x_vel = x_vel
   self.y_vel = y_vel
end

function EnemyShip:collidesWith(x, y, to_x, to_y)
   return self.x < x+to_x and
      to_x < self.x + self.to_x and
      self.y < y+to_y and
      to_y < self.y + self.to_y
end

function EnemyShip:setParent(parent)
   self.parent = parent
end
