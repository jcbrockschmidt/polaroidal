function love.load()
   require "polar"
   require "playerGraph"

   love.graphics.setBackgroundColor(255, 255, 255)

   newGraph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0,
      50,
      0, 3, 5
   )
   playerGraph.load()
end

function love.update(dt)
   playerGraph.update(dt)
end

function love.keypressed(key)
   playerGraph.keypressed(key)
end

function love.keyreleased(key)
   playerGraph.keyreleased(key)
end

function love.draw()
   love.graphics.setColor(0, 0, 0)
   love.graphics.circle(
      "line",
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      10
   )
   love.graphics.setColor(100, 100, 100)
   newGraph:draw(3)

   playerGraph.draw()
end
