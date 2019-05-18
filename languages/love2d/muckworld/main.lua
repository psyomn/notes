require "ship"
require "music"

function love.load()
   -- TODO: uncomment me when done
   -- muckTheme:play()

   ship = Ship:new(10, 10)

   bkg = love.graphics.newImage("img/Sludge.png")
   bkg:setWrap("repeat", "repeat")

   -----------------------------------------------

   quadCoord = {}
   quadCoord.x = 0
   quadCoord.y = 0


   bgQuad = love.graphics.newQuad(
      0, 0,
      896 + bkg:getWidth(),
      600 + bkg:getHeight(),
      bkg:getDimensions())

   quadCoord.x = (quadCoord.x - math.cos(0) ) % bkg:getWidth()
   quadCoord.y = (quadCoord.y - math.sin(0) ) % bkg:getHeight()
end

function love.update(dt)
   ship:update(dt)
end

function love.draw()
   love.graphics.draw(
      bkg, bgQuad,
      quadCoord.x - bkg:getWidth(),
      quadCoord.y - bkg:getHeight())

   ship:draw()
end
