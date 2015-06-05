-- State for displaying a player's score after a game has ended
--DOIT: add exit effect

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
      0, 0,
      0, 27,
      0, 0.2, 11
   ),
   graphThickness = 5,
   graphRadSpeed = 0.5
}

local graph = states.dispScore.graph

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

   graph:set_x(love.graphics.getWidth() / 2)
   graph:set_y(
      states.dispScore.score_y +
	 fonts.dispScore_score:getHeight("0") / 2 - 4
   )

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
   -- Account for different sizes of font number to better center displayed score
   local w = 0
   local x = love.graphics.getWidth() / 2
   local digits = {}
   for d in string.gmatch(tostring(score.score), "%d") do
      table.insert(digits, d)
   end
   for d_i, d in ipairs(digits) do
      local add_w = fonts.dispScore_score:getWidth(d)
      w = w + add_w
      x = x - add_w / 2
   end
   if digits[1] == "1" then
      -- 1's have some extra space on the left side.
      -- If the first digit is a 1, ignore this space.
      w = w - 15
      x = x - 7.5
   end

   -- All number have some extra space on their right side.
   -- Ignore this space on the last digit.
   w = w - 4
   x = x + 4

   states.dispScore.score_x = x

   states.dispScore.graph:set_a(0)
   states.dispScore.graph:snapTo("a", 3)
   states.dispScore.graph:set_n(math.random(1, 10))
end

function states.dispScore.update(dt)
   graph:update(dt)
   graph:calcPoints()
   -- Rotate graph
   local newRads = graph:get_rads() + states.dispScore.graphRadSpeed * dt
   while newRads >= 2*math.pi do
      newRads = newRads - 2*math.pi
   end
   print(newRads)
   graph:set_rads(newRads)
end

function states.dispScore.exit(func, ...)
   --DOIT: Visual effects
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
