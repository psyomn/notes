require "init"
require "obstacle"

-- This should create debris etc, where the player has to avoid
GarbageGenerator = {}
GarbageGenerator.__index = GarbageGenerator

function GarbageGenerator:new()
   local gg = {}
   setmetatable(gg, GarbageGenerator)

   gg.curr = 0.0
   gg.items = {}

   return gg
end

function GarbageGenerator:update(dt)
   self.curr = self.curr + dt

   for i, el in ipairs(self.items) do
      el:update(dt)
   end

   if self.curr >= 1.0 then
      -- generate debris
      self.curr = 0.0

      local r = math.random(1, 10)
      local pos_x = math.random(1, 2)
      local pos_y = math.random(1, 2)
      local niceness = 100
      local the_x, the_y = 0, 0
      local std_vel = 100.0
      local the_x_vel, the_y_vel = 0.0, 0.0

      if r >= 5 then
         -- TODO: 10% chance to generate somehting
         local gchoice = math.random(1, 2)

         -- calculate where to place the object
         if pos_x == 1 then -- left
            the_x = 0 - niceness
            the_x_vel = std_vel
         else -- right
            the_x = love.graphics.getWidth() + niceness
            the_x_vel = -std_vel
         end

         if pos_y == 1 then -- top
            the_y = 0 - niceness
            the_y_vel = std_vel
         else -- bottom
            the_y = love.graphics.getHeight() + niceness
            the_y_vel = -std_vel
         end

         obs = nil
         if gchoice == 1 then
            obs = Obstacle:makeSunkenTruck(the_x, the_y)
         elseif gchoice == 2 then
            obs = Obstacle:makeLamp(the_x, the_y)
         else
            print("garbage generator: did not know that choice")
            os.exit(1)
         end

         obs:setVelocity(the_x_vel, the_y_vel)

         table.insert(self.items, obs)
      end
   end

   -- Cleanup
   newlist = {}
   for i, el in ipairs(self.items) do
      nicety = 100
      maxX = love.graphics.getWidth() + nicety
      maxY = love.graphics.getHeight() + nicety
      minX = 0 - nicety
      minY = 0 - nicety

      if not el:isExpired(maxX, maxY, minX, minY) then
         table.insert(newlist,el)
      end
   end

   self.items = newlist
end

function GarbageGenerator:draw()
   for i, el in pairs(self.items) do
      el:draw()
   end
end
