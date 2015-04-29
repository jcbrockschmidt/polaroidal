local alpha
local isFading
local backFade
local fadeTimerID
local fadeFinal = 100
local fadeDelta = fadeFinal / 0.25

states.game = {
   pauseBtns = {
      colors = {
	 regular = {200, 200, 255, 255},
	 selected = {0, 0, 255, 255},
	 divider = {100, 100, 255, 255}
      },
      text = {
	 "Resume",
	 "Exit",
	 "Quit"
      },
      selector_x = 290,
      div_h = 4,
      div_w = 150,
      spacer_w = 8,
      spacer_h = 6,
      x = 300,
      y = 150
   }
}

function states.game.load()
   matchGraph.load()
   score.load()
   game.load()

   states.game.pauseBtns.btn_h = fonts.menu:getHeight(" ") + 6
   states.game.pauseBtns.pause_x =
      (love.graphics.getWidth() - fonts.score:getWidth("PAUSED")) / 2
   states.game.pauseBtns.pause_h = fonts.score:getHeight(" ")
   states.game.pauseBtns.pause_div_w = 300
   states.game.pauseBtns.pause_div_h = 8
   states.game.pauseBtns.pause_div_x =
      (love.graphics.getWidth() - states.game.pauseBtns.pause_div_w) / 2
end

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

function states.game.openPause()
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

   states.game.pauseBtns.selected = 1
end

function states.game.closePause()
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

function states.game.keypressed(key)
   if pause then

      if key == "escape" then
         states.game.closePause()

      elseif key == "w" or key == "i" or key == "up" then
	 states.game.pauseBtns.selected = states.game.pauseBtns.selected - 1
	 if states.game.pauseBtns.selected <= 0 then
	    states.game.pauseBtns.selected = #states.game.pauseBtns.text
	 end

      elseif key == "s" or key == "k" or key == "down" then
	 states.game.pauseBtns.selected = states.game.pauseBtns.selected + 1
	 if states.game.pauseBtns.selected > #states.game.pauseBtns.text then
	    states.game.pauseBtns.selected = 1
	 end

      elseif key == " " or key == "return" then
	 if states.game.pauseBtns.selected == 1 then
	    -- Resume
	    states.game.closePause()

	 elseif states.game.pauseBtns.selected == 2 then
	    -- End Game
	    states.game.closePause()
	    game.stop(
	       function()
		  timers.new(
		     2,
		     function()
			load_state("menu")
		     end
		  )
	       end
	    )

	 elseif states.game.pauseBtns.selected == 3 then
	    -- Quit
	    states.game.closePause()
	    game.stop(
	       function()
		  timers.new(
		     2,
		     function()
			love.event.quit()
		     end
		  )
	       end
	    )
	 end
      end

   elseif key == "escape" then
      states.game.openPause()

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

      local y = states.game.pauseBtns.y

      -- Draw pause text
      love.graphics.setFont(fonts.score)
      love.graphics.setColor(states.game.pauseBtns.colors.selected)
      love.graphics.print(
	 "PAUSED",
	 states.game.pauseBtns.pause_x,
	 y
      )
      y = y + states.game.pauseBtns.pause_h + states.game.pauseBtns.spacer_h

      -- Draw pause divider
      love.graphics.setColor(states.game.pauseBtns.colors.divider)
      love.graphics.rectangle(
	 "fill",
	 states.game.pauseBtns.pause_div_x, y,
	 states.game.pauseBtns.pause_div_w,
	 states.game.pauseBtns.pause_div_h
      )
      y = y + states.game.pauseBtns.div_h + states.game.pauseBtns.spacer_h * 2

      -- Draw buttons
      love.graphics.setFont(fonts.menu)
      local last = #states.game.pauseBtns.text
      for n, text in ipairs(states.game.pauseBtns.text) do
	 if n == states.game.pauseBtns.selected then
	    love.graphics.setColor(states.game.pauseBtns.colors.selected)
	    love.graphics.print(
	       ">",
	       states.game.pauseBtns.selector_x, y
	    )
	 else
	    love.graphics.setColor(states.game.pauseBtns.colors.regular)
	 end
	 love.graphics.print(
	    text,
	    states.game.pauseBtns.x + states.game.pauseBtns.spacer_w,
	    y
	 )

	 if n ~= last then
	    y = y + states.game.pauseBtns.btn_h
	    -- Draw divider
	    love.graphics.setColor(states.game.pauseBtns.colors.divider)
	    love.graphics.rectangle(
	       "fill",
	       states.game.pauseBtns.x, y,
	       states.game.pauseBtns.div_w, states.game.pauseBtns.div_h
	    )
	    y = y + states.game.pauseBtns.div_h + states.game.pauseBtns.spacer_h
	 end
      end
   end
end
