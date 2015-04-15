game = {
   timer = {
      color = {200, 200, 255, 255}
   }
}

function game.load()
   game.timer.x = 72
   game.timer.y = 72
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

function game.timer.update(dt)
   game.timer.t_cur = game.timer.t_cur - dt
   if game.timer.t_cur <= 0 then
      game.timer.active = false
      game.timer.t_cur = 0
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
