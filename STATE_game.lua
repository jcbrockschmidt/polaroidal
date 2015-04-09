states.game = {}

function states.game.reload()
   score.reload()
end

function states.game.update(dt)
   playerGraph.update(dt)
   matchGraph.update(dt)
   score.update(dt)
end

function states.game.keypressed(key)
   playerGraph.keypressed(key)
   if key == "up" then
      score.set(score.score + 1)
   elseif key == "down" then
      score.set(score.score - 1)
   end
end

function states.game.keyreleased(key)
   playerGraph.keyreleased(key)
end

function states.game.draw()
   matchGraph.draw()
   playerGraph.draw()
   score.draw()
end
