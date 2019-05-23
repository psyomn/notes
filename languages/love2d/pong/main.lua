require "pad"
require "ball"

function love.load()
   windowWidth = love.graphics.getWidth()
   windowHeight = love.graphics.getHeight()

   padu = Pad:new(10, 10, 10, 100)
   pade = Pad:new(windowWidth - 20, 10, 10, 100)

   ball = Ball:new(windowWidth / 2, windowHeight / 2)

   padu:isHuman(true)
   pade:isHuman(false) -- this will make it be ai

   updateable = {padu, pade, ball}
   drawable = {padu, pade, ball}
end

function love.update(dt)
   for i, el in pairs(updateable) do
      el:update(dt)
   end

   if ball:collidesWith(padu) then
      ball:setVelRight()
   end

   if ball:collidesWith(pade) then
      ball:setVelLeft()
   end
end

function love.draw()
   for i, el in pairs(drawable) do
      el:draw()
   end
end
