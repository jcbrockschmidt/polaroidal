function love.load()
   require "library"
   require "polar"
   require "playerGraph"
   require "matchGraph"
   require "score"

   love.graphics.setBackgroundColor(255, 255, 255)

   fonts = {
      extraOrdinaryi = love.graphics.newFont("fonts/EXTRAORDINARI CRAFT.ttf", 20),
      oblivious = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 20),
      nightfever = love.graphics.newFont("fonts/DBXL Nightfever pc ttfs/DBXLNEW_.TTF", 20),

      score = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 70)
   }

   --DEBUG
   debugFont = love.graphics.newFont(16)
   --EOF DEBUG

   newGraph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0,
      50,
      0, 3, 0
   )
   playerGraph.load()
   matchGraph.load()

   score.load()
end

function love.update(dt)
   playerGraph.update(dt)
   matchGraph.update(dt)
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

   matchGraph.draw()
   playerGraph.draw()

   score.draw()
end
