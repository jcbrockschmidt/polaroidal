score = {
   color = {0, 0, 0, 255},
   x = 50,
   y = 40
}

function score.reload()
   score.score = 0
end

function score.set(newScore)
   score.score = newScore
end

function score.incr(incr)
   score.score = score.score + incr
end

function score.draw()
   love.graphics.setColor(score.color)
   love.graphics.setFont(fonts.score)
   love.graphics.print(
      score.score,
      score.x, score.y
   )
end
