require "ship"
require "music"
require "obstacle"
require "garbage_generator"

function love.load()
   -- TODO: uncomment me when done
   -- muckTheme:play()

   --Intro assets---------------------------------------------
   -----------------------------------------------------------
   gameState = "intro"
   titleImg = love.graphics.newImage("img/garbologo.png")
   titleImgScaleX = 0
   titleImgScaleY = 0
   textCounter = 0
   textVisible = false

   --Debris---------------------------------------------------
   -----------------------------------------------------------
   garbage_generator = GarbageGenerator:new()

   --Background-----------------------------------------------
   -----------------------------------------------------------

   ship = Ship:new(10, 10)

   bkg = love.graphics.newImage("img/Sludge.png")
   bkg:setWrap("repeat", "repeat")

   quadcoord = {}
   quadcoord.x = 0
   quadcoord.y = 0

   bgQuad = love.graphics.newQuad(
      0, 0,
      love.graphics.getWidth() + bkg:getWidth(),
      love.graphics.getHeight() + bkg:getHeight(),
      bkg:getDimensions())

   quadcoord.x = quadcoord.x % bkg:getWidth()
   quadcoord.y = quadcoord.y % bkg:getHeight()

   updateableList = {garbage_generator, ship}
   drawableList = {garbage_generator, ship}

end

function love.update(dt)
   if gameState == "intro" then
      textCounter = textCounter + dt

      if love.keyboard.isDown("space") then
         gameState = "playing"
      end

      if titleImgScaleX > 0.04 then
         return
      end

      if textCounter == 1 then
         textVisible = not textVisible
         textCounter = 0
      end

      titleImgScaleX = math.sin(titleImgScaleX + dt / 10)
      titleImgScaleY = math.sin(titleImgScaleY + dt / 10)
      return
   end

   for i, el in ipairs(updateableList) do
      el:update(dt)
   end
end

function love.draw()
   if gameState == "intro" then
      love.graphics.draw(
         titleImg,
         love.graphics.getWidth() / 2,
         love.graphics.getHeight() / 2,
         0,
         titleImg:getWidth() * titleImgScaleX,
         titleImg:getHeight() * titleImgScaleY,
         titleImg:getWidth() / 2,
         titleImg:getHeight() / 2
      )

      love.graphics.print(
         "Press [SPACE] to start game",
         0,
         love.graphics.getHeight() - 50,
         0, 2, 2)

      return
   end

   love.graphics.draw(
      bkg, bgQuad,
      quadcoord.x - bkg:getWidth(),
      quadcoord.y - bkg:getHeight())

   for i, el in pairs(drawableList) do
      el:draw()
   end
end
