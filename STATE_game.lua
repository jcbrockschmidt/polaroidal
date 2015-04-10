local alpha
local isFading
local fadeFinal = 100
local fadeTime = 1
local fadeDelta = fadeFinal / fadeTime

states.game = {}

function states.game.reload()
   score.reload()
end

function states.game.update(dt)
   timers.update(dt)

   if not pause then
      playerGraph.update(dt)
      matchGraph.update(dt)
      score.update(dt)
   end

   if pause and isFading then
      alpha = alpha + fadeDelta*dt
   end
end

function states.game.keypressed(key)
   if pause then

      if key == "escape" then
	 pause = false
      end

   elseif key == "escape" then
      pause = true

      isFading = true
      alpha = 0
      timers.new(
	 fadeTime,
	 function()
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
   score.draw()

   if pause then
      -- Draw haze over screen
      love.graphics.setColor(0, 0, 0, alpha)
      love.graphics.rectangle(
	 "fill",
	 0, 0,
	 love.graphics.getWidth(),
	 love.graphics.getHeight()
      )
   end
end
