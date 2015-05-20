-- State for displaying a player's score after a game has ended

states.dispScore = {
   colors = {
      msg = {0, 0, 255, 255},
      line = {100, 100, 255, 255},
      graph = {0, 0, 127, 255},
      score = {0, 0, 255, 255},
      msg2 = {200, 200, 255, 255}
   },

   msg = "Your final score",
   msg2 = "Click any key",
   msg3 = "to go to the main menu...",

   graph = polar.new(
      love.graphics.getWidth() / 2 - 5,
      love.graphics.getHeight() / 2 - 5,
      0, 27,
      0, 0, 0
   ),
   graphThickness = 5
}

function states.dispScore.load()
   states.dispScore.score_y =
      (love.graphics.getHeight() - 
	  fonts.dispScore_score:getHeight("0")) / 2

   states.dispScore.msg_x =
      (love.graphics.getWidth() -
	  fonts.dispScore_msg:getWidth(states.dispScore.msg)) / 2
   states.dispScore.msg_y = 
      states.dispScore.score_y - fonts.dispScore_msg:getHeight(" ") - 60

   states.dispScore.line_x = states.dispScore.msg_x
   states.dispScore.line_y =
      states.dispScore.msg_y + fonts.dispScore_msg:getHeight(" ") + 5
   states.dispScore.line_w = fonts.dispScore_msg:getWidth(states.dispScore.msg) * 0.9
   states.dispScore.line_h = 5

   states.dispScore.msg2_x = 
      (love.graphics.getWidth() -
	  fonts.dispScore_msg2:getWidth(states.dispScore.msg2)) / 2
   states.dispScore.msg2_y =
      states.dispScore.score_y + fonts.dispScore_score:getHeight(" ") + 30

   states.dispScore.msg3_x = 
      (love.graphics.getWidth() -
	  fonts.dispScore_msg2:getWidth(states.dispScore.msg3)) / 2
   states.dispScore.msg3_y =
      states.dispScore.msg2_y + fonts.dispScore_msg2:getHeight(" ")
end

function states.dispScore.reload()
   states.dispScore.score_x =
      (love.graphics.getWidth() -
	  fonts.dispScore_score:getWidth(tostring(score.score))) / 2

   states.dispScore.graph:set_a(0)
   states.dispScore.graph:snapTo("a", 3)
end

function states.dispScore.update(dt)
   states.dispScore.graph:update(dt)
   states.dispScore.graph:calcPoints()
end

function states.dispScore.exit(func, ...)
   --DOIT
   -- Call func() after
   local arg = {...}
   func(unpack(arg))
end

-- Return to main menu if any key is pressed
function states.dispScore.keypressed()
   states.dispScore.exit(load_state, "menu")
end

function states.dispScore.draw()
   -- Display background graph
   love.graphics.setColor(states.dispScore.colors.graph)
   states.dispScore.graph:draw(states.dispScore.graphThickness)

   -- Display message
   love.graphics.setColor(states.dispScore.colors.msg)
   love.graphics.setFont(fonts.dispScore_msg)
   love.graphics.print(
      states.dispScore.msg,
      states.dispScore.msg_x,
      states.dispScore.msg_y
   )

   -- Display score underline
   love.graphics.setColor(states.dispScore.colors.line)
   love.graphics.rectangle(
      "fill",
      states.dispScore.line_x, states.dispScore.line_y,
      states.dispScore.line_w, states.dispScore.line_h
   )

   -- Display score
   love.graphics.setColor(states.dispScore.colors.score)
   love.graphics.setFont(fonts.dispScore_score)
   love.graphics.print(
      score.score,
      states.dispScore.score_x,
      states.dispScore.score_y
   )

   -- Display second message
   love.graphics.setColor(states.dispScore.colors.msg2)
   love.graphics.setFont(fonts.dispScore_msg2)
   love.graphics.print(
      states.dispScore.msg2,
      states.dispScore.msg2_x,
      states.dispScore.msg2_y
   )
   love.graphics.print(
      states.dispScore.msg3,
      states.dispScore.msg3_x,
      states.dispScore.msg3_y
   )
end
