
game = {
   timer = {
      color = {200, 200, 255, 255},
      trans_accel = 2*math.pi
   },

   stopping = {
      signs = {
	 plyr = {},
	 match = {}
      }
   }
}

function game.load()
   game.timer.x = 72
   game.timer.y = 72
end

function game.reload()
   game.stopping.isStopping = false
   game.adjustScale = true
   game.timer.active = false
   game.timer.t_orig = 0
   game.timer.t_cur = 0
   game.timer.trans = false
   game.timer.trans_speed = 0
end

-- Valide modes:
--  "challenge"
--  "timed"
--  "casual"
function game.new(mode, ...)
   local arg = {...}

   pause = false
   load_state("game")
   if mode == "casual" then
      --DOIT

   elseif mode == "timed" then
      game.timer.set(arg[1])

   elseif mode == "challenge" then
      --DOIT
   end
end

function game.stop(endFunc)
   game.stopping.isStopping = true
   game.stopping.endFunc = endFunc

   game.timer.set(game.timer.t_orig, false)

   game.adjustScale = false

   playerGraph.canMove = false
   matchGraph.canShuffle = false
   for _, par in pairs({"a", "b", "n"}) do
      game.stopping.signs.plyr[par] =
	 (playerGraph.graph["get_"..par](playerGraph.graph) > 0)
      game.stopping.signs.match[par] =
	 (matchGraph.graph["get_"..par](matchGraph.graph) > 0)
   end

   -- Delay collapsing of graphs
   timers.new(
      1,
      function()
	 for _, par in pairs({"a", "b", "n"}) do
	    matchGraph.graph:snapTo(par, 0)
	 end
      end
   )
   timers.new(
      2,
      function()
	 for _, par in pairs({"a", "b", "n"}) do
	    playerGraph.graph:snapTo(par, 0)
	 end
      end
   )
end

function game.update(dt)
   if game.timer.active then
      game.timer.update(dt)
   end

   if game.adjustScale then
      local newScale = (love.graphics.getHeight() / 2) /
	 (math.max(playerGraph.graph:get_peak(), matchGraph.graph:get_peak()) * 1.2)
      playerGraph.graph:set_scale(newScale)
      matchGraph.graph:set_scale(newScale)
   end

   if game.stopping.isStopping then
      local done = true

      for par, plyrSign in pairs(game.stopping.signs.plyr) do
	 local matchSign = game.stopping.signs.match[par]

	 if (plyrSign and (playerGraph.graph["get_"..par](playerGraph.graph) <= 0))
	 or ((not plyrSign) and (playerGraph.graph["get_"..par](playerGraph.graph) >= 0))
	 then
	    playerGraph.graph["set_"..par](playerGraph.graph, 0)
	    playerGraph.graph:halt(par)
	 else
	    done = false
	 end

	 if (matchSign and (matchGraph.graph["get_"..par](matchGraph.graph) <= 0))
	 or ((not matchSign) and (matchGraph.graph["get_"..par](matchGraph.graph) >= 0))
	 then
	    matchGraph.graph["set_"..par](matchGraph.graph, 0)
	    matchGraph.graph:halt(par)
	 else
	    done = false
	 end
      end

      if done then
	 game.stopping.isStopping = false
	 timers.new(
	    1,
	    game.stopping.endFunc
	 )
      end
   end
end

function game.timer.set(t, dir)
   if dir == nil then
      dir = true
   end

   game.timer.active = true
   game.timer.trans = true
   -- Make speed does not equal 0 so game does not immediately terminate
   game.timer.trans_speed = dir and 0.1 or -0.1
   -- If true, t_cur must go below t_target
   -- If false, t_cur must go above t_target
   game.timer.transDir = dir

   local percent = (game.timer.t_orig ~= 0)
      and game.timer.t_cur / game.timer.t_orig
      or 0
   game.timer.t_orig = t
   game.timer.t_cur = t * percent
   game.timer.t_target = dir and game.timer.t_orig or 0
end

function game.timer.update(dt)
   if game.timer.trans then
      -- If transDir is true, increase timer
      -- If transDir is false, decrease timer
      local sign = game.timer.transDir and 1 or -1
      -- Calculate how long it'd take for the timer ring to decelerate and stop
      local t = game.timer.trans_speed / game.timer.trans_accel
      -- Calculate how many rads ring would change by if ring started decelerating now
      local rads = game.timer.trans_speed + (0.5 * -game.timer.trans_speed * t*t)

      -- See if timer ring needs to be pushed a bit further before decelerating
      -- Subtract a bit to rads so deceleration is slightly delayed
      if rads-math.pi <=
      ((game.timer.t_orig-game.timer.t_target) / game.timer.t_orig) * 2*math.pi
      then
	 game.timer.trans_speed = game.timer.trans_speed + sign*game.timer.trans_accel*dt
      else
	 game.timer.trans_speed = game.timer.trans_speed - sign*game.timer.trans_accel*dt
      end

      -- Convert rad increase speed to time increase speed
      game.timer.t_cur = game.timer.t_cur +
	 (game.timer.t_orig * game.timer.trans_speed/(2*math.pi)) * dt

      local done = false
      if game.timer.transDir then
	 if game.timer.t_cur >= game.timer.t_target
	 or game.timer.trans_speed <= 0 then
	    done = true
	 end
      elseif game.timer.t_cur <= game.timer.t_target
      or game.timer.trans_speed >= 0 then
	 done = true
	 game.timer.active = false
      end

      if done then
	 game.timer.trans = false
	 game.timer.t_cur = game.timer.t_target
      end
   else
      game.timer.t_cur = game.timer.t_cur - dt
      if game.timer.t_cur <= 0 then
	 game.timer.active = false
	 game.timer.t_cur = 0

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
      end
   end
end

function game.timer.draw()
   love.graphics.setColor(game.timer.color)
   love.graphics.setLineWidth(5)
   love.graphics.arc(
      "line", game.timer.x, game.timer.y,
      50,
      0, 2*math.pi * (game.timer.t_cur/game.timer.t_orig)
   )
end
