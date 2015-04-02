function love.load()
   require "library"
   require "polar"
   require "playerGraph"
   require "matchGraph"
   require "menu"
   require "score"

   require "states"
   require "STATE_menu"

   love.graphics.setBackgroundColor(255, 255, 255)

   fonts = {
      oblivious = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 20),
      menu = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 40),
      score = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 70)
   }

   --DEBUG
   debugFont = love.graphics.newFont(16)
   --EOF DEBUG

   playerGraph.load()
   matchGraph.load()
   score.load()
   menu.load()

   load_state("menu")
end
