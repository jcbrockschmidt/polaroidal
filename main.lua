function love.load()
   math.randomseed(os.time())

   require "game"
   require "highscores"
   require "library"
   require "polar"
   require "playerGraph"
   require "matchGraph"
   require "menu"
   require "score"
   require "timers"

   require "states"
   require "STATE_dispScore"
   require "STATE_game"
   require "STATE_menu"

   love.graphics.setBackgroundColor(255, 255, 255)

   fonts = {
      oblivious = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 20),
      menu = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 40),
      score = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 70),
      dispScore_score = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 120),
      dispScore_msg = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 50),
      dispScore_msg2 = love.graphics.newFont("fonts/OBLIVIOUSFONT.TTF", 35)
   }

   --DEBUG
   debugFont = love.graphics.newFont(16)
   --EOF DEBUG

   states.dispScore.load()
   states.menu.load()
   states.game.load() 

   highscores.readData()

   load_state("menu")
end
