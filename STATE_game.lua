states.game = {}

function states.game.reload()
   score.reload()
end

function states.game.update(dt)
   playerGraph.update(dt)
   matchGraph.update(dt)
end

function states.game.keypressed(key)
   playerGraph.keypressed(key)
end

function states.game.keyreleased(key)
   playerGraph.keyreleased(key)
end

function states.game.draw()
   matchGraph.draw()
   playerGraph.draw()
   score.draw()
end
