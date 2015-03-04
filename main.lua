function love.load()
   require "polar"
   newGraph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0,
      100,
      0, 1, 5
   )

   love.graphics.setBackgroundColor(255, 255, 255)
end

function love.update(dt)
   return --> place-holder; temporary
end

function love.draw()
   love.graphics.setColor(0, 0, 0)
   love.graphics.circle(
      "line",
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      5
   )
   newGraph:draw()
end
