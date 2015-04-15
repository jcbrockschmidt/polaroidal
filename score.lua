score = {
   numColor = {0, 0, 255, 255},
   x = 50,
   y = 40,
   line = {
      color = {100, 100, 255, 255},
      w = 0,
      h = 10,
      speed = 0,
      accel = 100,
      maxSpeed = 150
   }
}

local line = score.line

function score.load()
   line.x = score.x
   line.y = score.y + fonts.score:getHeight(" ") - 5
end

function score.reload()
   line.speed = 0
   line.w = 0
   line.w_goal = 0
   line.adjust = false
   score.set(50)
end

function score.update(dt)
   if line.w ~= line.w_goal then
      if (3*line.speed*line.speed) / (2*line.accel) < math.abs(line.w_goal - line.w) then
	 if line.w < line.w_goal then
	    line.speed = math.min(line.maxSpeed, line.speed + line.accel*dt)
	 else
	    line.speed = math.max(-line.maxSpeed, line.speed - line.accel*dt)
	 end
      else
	 if line.w < line.w_goal then
	    line.speed = math.max(0, line.speed - line.accel*dt)
	 else
	    line.speed = math.min(0, line.speed + line.accel*dt)
	 end

	 if line.speed == 0 then
	    line.adjust = false
	    line.w = line.w_goal
	    return
	 end
      end

      line.w = line.w + line.speed*dt
   end
end

function score.set(newScore)
   score.score = newScore

   -- Update underline width
   local digits = (score.score == 0)
      and 1
      or (math.floor(math.log10(math.abs(score.score))) + 1)

   -- Account for negative sign
   if score.score < 0 then
      digits = digits + 1
   end

   line.w_goal = digits * fonts.score:getWidth(" ")
   if line.w_goal ~= line.w then
      line.adjust = true
      -- Initialize speed so line adjustment doesn't immediately halt
      line.speed = (line.w_goal > line.w) and 0.01 or -0.01
   end
end

function score.incr(incr)
   score.score = score.score + incr
end

function score.draw()
   -- Draw score
   love.graphics.setColor(score.numColor)
   love.graphics.setFont(fonts.score)
   love.graphics.print(
      score.score,
      score.x, score.y
   )

   -- Draw underline
   love.graphics.setColor(score.line.color)
   love.graphics.rectangle(
      "fill",
      score.line.x,
      score.line.y,
      score.line.w,
      score.line.h
   )
end
