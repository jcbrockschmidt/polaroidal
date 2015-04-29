--DOIT: * create function for ending the game
--         - have graph's disappear after parameters have reached or gone past 0
--      * have timer rapidly deplete once game begins stopping

game = {
   timer = {
      color = {200, 200, 255, 255}
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
      game.timer.active = false
      --DOIT
   elseif mode == "timed" then
      game.timer.active = true
      game.timer.t_orig = arg[1]
      game.timer.t_cur = arg[1]
   end
   --DOIT
end

function game.stop(endFunc)
   game.stopping.isStopping = true
   game.stopping.endFunc = endFunc

   game.adjustScale = false

   playerGraph.canMove = false
   matchGraph.canShuffle = false
   for _, par in pairs({"a", "b", "n"}) do
      matchGraph.graph:snapTo(par, 0)
      game.stopping.signs.plyr[par] =
	 (playerGraph.graph["get_"..par](playerGraph.graph) > 0)
      game.stopping.signs.match[par] =
	 (matchGraph.graph["get_"..par](matchGraph.graph) > 0)
   end

   -- Delay collapsing of player's graph
   timers.new(
      1,
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

function game.timer.update(dt)
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

function game.timer.draw()
   love.graphics.setColor(game.timer.color)
   love.graphics.setLineWidth(5)
   love.graphics.arc(
      "line", game.timer.x, game.timer.y,
      50,
      0, 2*math.pi * (game.timer.t_cur/game.timer.t_orig)
   )
end
