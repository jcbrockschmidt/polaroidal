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

playerGraph.maxLimits = {
   a = 7,
   b = 6,
   n = 10
}

playerGraph.minLimits = {
   a = -7,
   b = -6,
   n = -10
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
local maxLimits = playerGraph.maxLimits
local minLimits = playerGraph.minLimits

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
end

function playerGraph.setIncr(k, bool)
   doIncr[k] = bool
   if bool then
      doDecr[k] = false
   elseif love.keyboard.isDown(km["decr_"..k]) then
      doDecr[k] = true
   else
      playerGraph.getSnap(k)
   end
end

function playerGraph.setDecr(k, bool)
   doDecr[k] = bool
   if bool then
      doIncr[k] = false
   elseif love.keyboard.isDown(km["incr_"..k]) then
      doIncr[k] = true
   else
      playerGraph.getSnap(k)
   end
end

function playerGraph.update(dt)
   local polarPars = {
      a = graph:get_a(),
      b = graph:get_b(),
      n = graph:get_n()
   }

   for k, v in pairs(polarPars) do
      if doIncr[k] then
	 if v > maxLimits[k] then
	    playerGraph.setIncr(k, false)
	 end

      elseif doDecr[k] then
	 if v < minLimits[k] then
	    playerGraph.setDecr(k, false)
	 end
      end

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
   for _, k in ipairs({"a", "b", "n"}) do
      if key == km["incr_"..k] then
	 playerGraph.setIncr(k, true)
	 return
      elseif key == km["decr_"..k] then
	 playerGraph.setDecr(k, true)
	 return
      end
   end
end

function playerGraph.keyreleased(key)
   for _, k in ipairs({"a", "b", "n"}) do
      if key == km["incr_"..k] then
	 playerGraph.setIncr(k, false)
	 return
      elseif key == km["decr_"..k] then
	 playerGraph.setDecr(k, false)
	 return
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
