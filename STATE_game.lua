local alpha
local isFading
local backFade
local fadeTimerID
local fadeFinal = 100
local fadeDelta = fadeFinal / 0.25

states.game = {}

function states.game.reload()
   playerGraph.reload()
   matchGraph.reload()
   score.reload()
   game.reload()

   alpha = 0
end

function states.game.update(dt)
   timers.update(dt)

   if not pause then
      playerGraph.update(dt)
      matchGraph.update(dt)
      score.update(dt)
      game.update(dt)
   end

   if isFading then
      if backFade then
         alpha = alpha - fadeDelta*dt
      else
         alpha = alpha + fadeDelta*dt
      end
   end
end

function states.game.keypressed(key)
   if pause then

      if key == "escape" then
         pause = false

         isFading = true
         backFade = true

	 if fadeTimerID then
	    timers.del(fadeTimerID)
	 end

         fadeTimerID = timers.new(
            alpha / fadeDelta,
            function()
	       fadeTimerID = nil
	       alpha = 0
               isFading = false
            end
         )
      end

   elseif key == "escape" then
      pause = true

      isFading = true
      backFade = false

      if fadeTimerID then
	 timers.del(fadeTimerID)
      end

      fadeTimerID = timers.new(
	 (fadeFinal - alpha) / fadeDelta,
	 function()
	    fadeTimerID = nil
	    alpha = fadeFinal
	    isFading = false
	 end
      )
   else
      playerGraph.keypressed(key)
   end
end

function states.game.keyreleased(key)
   if pause then

   else
      playerGraph.keyreleased(key)
   end
end

function states.game.draw()
   matchGraph.draw()
   playerGraph.draw()
   if game.timer.active then
      game.timer.draw()
   end
   score.draw()

   if pause or isFading then
      -- Draw haze over screen
      love.graphics.setColor(0, 0, 0, alpha)
      love.graphics.rectangle(
	 "fill",
	 0, 0,
	 love.graphics.getWidth(),
	 love.graphics.getHeight()
      )
      -- Draw pause text
      if not isFading then
         love.graphics.setColor(0, 0, 255, 255)
         love.graphics.print("- PAUSED -", math.floor(love.graphics.getWidth() / 2) - 215, math.floor(love.graphics.getHeight() / 2) - 35)
      end
   end
end
