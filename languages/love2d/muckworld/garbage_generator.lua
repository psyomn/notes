require "init"
require "obstacle"

-- This should create debris etc, where the player has to avoid
GarbageGenerator = {}
GarbageGenerator.__index = GarbageGenerator

-- sunkenTruck = Obstacle:makeSunkenTruck(30, 50)
-- lamp = Obstacle:makeLamp(100, 200)
-- garbage = {sunkenTruck, lamp}

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

      if r >= 5 then
         local gchoice = math.random(1, 2)

         if gchoice == 1 then
            -- obs = Obstacle:makeSunkenTruck(
            --    math.random(love.graphics.getWidth()),
            --    math.random(love.graphics.getHeight()))
            obs = Obstacle:new(love.graphics.newImage("img/sunken_truck.png"), 30, 30)

            table.insert(self.items, obs)
         end

         if gchoice == 2 then
            -- obs = Obstacle:makeLamp(
            --    math.random(love.graphics.getWidth()),
            --    math.random(love.graphics.getHeight()))

            obs = Obstacle:new(love.graphics.newImage("img/64x32_Objects_to_put_in_Sludge.png"), 10, 10)

            table.insert(self.items, obs)
         end

         for i, el in ipairs(self.items) do
            el:print()
         end
      end
   end

   -- TODO cleanup debris
   -- newlist = {}
   -- for i, el in ipairs(self.items) do
   --    nicety = 100
   --    maxX = love.graphics.getWidth() + nicety
   --    maxY = love.graphics.getHeight() + nicety
   --    minX = 0 - nicety
   --    minY = 0 - nicety

   --    -- if not el:isExpired(maxX, maxY, minX, minY) then
   --    table.insert(newlist,el)
   --    -- end
   -- end

   -- self.items = newlist
end

function GarbageGenerator:draw()
   for i, el in pairs(self.items) do
      el:draw()
   end
end

function GarbageGenerator:getItems()
   return self.items
end
