require "polar"
require "matchGraph"

playerGraph = {}

playerGraph.graph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0,
      50,
      0, 3, 1
)

playerGraph.keyMaps = {
   incr_a = "i",
   decr_a = "k",
   incr_b = "u",
   decr_b = "o",
   incr_n = "j",
   decr_n = "l"
}

playerGraph.doIncr = {}

playerGraph.doDecr = {}

playerGraph.speeds = {}

playerGraph.maxSpeeds = {
   a = 12,
   b = 12,
   n = 12
}

playerGraph.accels = {
   a = 24,
   b = 24,
   n = 18
}

playerGraph.fricts = {
   a = -6,
   b = -6,
   n = -6
}

playerGraph.snap = {
   a = 0,
   b = 0,
   n = 0
}

playerGraph.snapFuzz = {
   a = 0.1,
   b = 0.1,
   n = 0.1,
}

playerGraph.snapSpeedFuzz = {
   a = 0.5,
   b = 0.5,
   n = 0.3
}

local graph = playerGraph.graph
local km = playerGraph.keyMaps
local doIncr = playerGraph.doIncr
local doDecr = playerGraph.doDecr
local speeds = playerGraph.speeds
local maxSpeeds = playerGraph.maxSpeeds
local accels = playerGraph.accels
local fricts = playerGraph.fricts
local snap = playerGraph.snap
local snapFuzz = playerGraph.snapFuzz
local snapSpeedFuzz = playerGraph.snapSpeedFuzz
local snapFuzz = playerGraph.snapFuzz
local snapSpeedFuzz = playerGraph.snapSpeedFuzz

function playerGraph.load()
   for _, k in pairs({"a", "b", "n"}) do
      doIncr[k] = false
      doDecr[k] = false
      speeds[k] = 0
      snap[k] = math.floor(graph["get_"..k](graph))
   end
end

function playerGraph.getSnap(k)
   snap[k] = math.floor(graph["get_"..k](graph) + 0.5)
   print("SNAP,",k,snap[k]);
end

function playerGraph.update(dt)
   local polarPars = {
      a = graph:get_a(),
      b = graph:get_b(),
      n = graph:get_n()
   }

   for k, v in pairs(polarPars) do
      if doIncr[k] then
	 speeds[k] = math.max(0, speeds[k] + fricts[k] * dt)
	 speeds[k] = math.min(maxSpeeds[k], speeds[k] + accels[k] * dt)

      elseif doDecr[k] then
	 speeds[k] = math.min(0, speeds[k] - fricts[k] * dt)
	 speeds[k] = math.max(-maxSpeeds[k], speeds[k] - accels[k] * dt)

      elseif math.abs(snap[k] - v) > snapFuzz[k] or
      math.abs(speeds[k]) > snapSpeedFuzz[k] then
	 if v > snap[k] then
	    speeds[k] = math.min(0, speeds[k] - fricts[k] * dt)
	    speeds[k] = math.max(-maxSpeeds[k], speeds[k] - accels[k] * dt)

	 elseif v < snap[k] then
	    speeds[k] = math.max(0, speeds[k] + fricts[k] * dt)
	    speeds[k] = math.min(maxSpeeds[k], speeds[k] + accels[k] * dt)
	 end

      else
	 speeds[k] = 0
	 polarPars[k] = snap[k]
      end

      graph["set_"..k](graph, polarPars[k] + speeds[k] * dt)
   end

   graph:calcPoints()
end

function playerGraph.keypressed(key)
   if key == km.incr_a then
      doIncr.a = true
      doDecr.a = false
   elseif key == km.decr_a then
      doDecr.a = true
      doIncr.a = false

   elseif key == km.incr_b then
      doIncr.b = true
      doDecr.b = false
   elseif key == km.decr_b then
      doDecr.b = true
      doIncr.b = false

   elseif key == km.incr_n then
      doIncr.n = true
      doDecr.n = false
   elseif key == km.decr_n then
      doDecr.n = true
      doIncr.n = false
   end
end

function playerGraph.keyreleased(key)
   if key == km.incr_a then
      doIncr.a = false
      if love.keyboard.isDown(km.decr_a) then
	 doDecr.a = true
      else
	 doDecr.a = false
	 playerGraph.getSnap("a")
      end
   elseif key == km.decr_a then
      doDecr.a = false
      if love.keyboard.isDown(km.incr_a) then
	 doIncr.a = true
      else
	 doIncr.a = false
	 playerGraph.getSnap("a")
      end

   elseif key == km.incr_b then
      doIncr.b = false
      if love.keyboard.isDown(km.decr_b) then
	 doDecr.b = true
      else
	 doDecr.b = false
	 playerGraph.getSnap("b")
      end
   elseif key == km.decr_b then
      doDecr.b = false
      if love.keyboard.isDown(km.incr_b) then
	 doIncr.b = true
      else
	 doIncr.b = false
	 playerGraph.getSnap("b")
      end

   elseif key == km.incr_n then
      doIncr.n = false
      if love.keyboard.isDown(km.decr_n) then
	 doDecr.n = true
      else
	 doDecr.n = false
	 playerGraph.getSnap("n")
      end
   elseif key == km.decr_n then
      doDecr.n = false
      if love.keyboard.isDown(km.incr_n) then
	 doIncr.n = true
      else
	 doIncr.n = false
	 playerGraph.getSnap("n")
      end
   end
end

function playerGraph.draw()
   love.graphics.setColor(0, 0, 127, 255)
   graph:draw(5)
   
   --DEBUGGING
   love.graphics.setColor(0, 200, 0, 255)
   love.graphics.print(
      "a:\t" .. graph:get_a()
	 .. "\nb:\t" .. graph:get_b()
	 .. "\nn:\t" .. graph:get_n(),
      5, 5
   )
   --EOF DEBUG
end
