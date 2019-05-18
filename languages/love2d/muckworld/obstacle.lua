Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:new(img, x, y)
   self.img = img
   self.x = x
   self.y = y
end

function Obstacle:update(dt)
end

function Obstacle:draw()
   love.graphics.draw(self.img, self.x, self.y)
end
