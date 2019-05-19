require "ship"
require "music"
require "obstacle"
require "garbage_generator"

function love.load()
   -- TODO: uncomment me when done
   muckTheme:play()

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
   gGenerator = GarbageGenerator:new()

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

   updateableList = {gGenerator, ship}
   drawableList = {gGenerator, ship}
end

function love.update(dt)
   if gameState == "intro" then
      textCounter = textCounter + dt

      if love.keyboard.isDown("space") then
         gameState = "playing"
      end

      if textCounter >= 1 then
         textVisible = not textVisible
         textCounter = 0
      end

      if titleImgScaleX > 0.04 then
         return
      end

      titleImgScaleX = math.sin(titleImgScaleX + dt / 10)
      titleImgScaleY = math.sin(titleImgScaleY + dt / 10)
      return
   end

   if gameState == "gameoverman" then
      if love.keyboard.isDown("space") then
         gameState = "intro"
         love.load()
         return
      end
   end

   for i, el in ipairs(updateableList) do
      el:update(dt)
   end

   -- check collisions
   for i, el in ipairs(updateableList) do
      if el ~= ship then
         ret = el:collidesWith(
            ship:getX(), ship:getY(),
            ship:getToX(), ship:getToY())

         -- TODO: uncomment if you want gameovers, man
         -- if ret then
         --    gameState = "gameoverman"
         -- end
      end
   end
end

function love.draw()
   if gameState == "intro" then
      love.graphics.draw(
         titleImg,
         love.graphics.getWidth() / 2,
         love.graphics.getHeight() / 2,
         0,
         titleImg:getWidth() * titleImgScaleX / 24,
         titleImg:getHeight() * titleImgScaleY / 24,
         titleImg:getWidth() / 2,
         titleImg:getHeight() / 2
      )

      if textVisible then
         love.graphics.print(
            "Press [SPACE] to start game",
            0,
            love.graphics.getHeight() - 50,
            0, 2, 2)
      end

      return
   end

   if gameState == "gameoverman" then
      love.graphics.print(
         "game over! Press space to restart",
         10,
         love.graphics.getHeight() / 2,
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
