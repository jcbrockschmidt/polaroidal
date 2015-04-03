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
local maxLimits = playerGraph.maxLimits
local minLimits = playerGraph.minLimits

function playerGraph.load()
   playerGraph.scale = playerGraph.getScale()
end

function playerGraph.reload()
   for _, par in pairs({"a", "b", "n"}) do
      doIncr[par] = false
      doDecr[par] = false

      graph["set_"..par](graph, 0)
      local snap = math.random(minLimits[par], maxLimits[par] - 1)
      -- Ensure new parameter is not zero to avoid having an invisible graph
      if snap >= 0 then snap = snap + 1 end
      graph:snapTo(snap)
   end
end

function playerGraph.getScale()
   return (love.graphics.getHeight() / 2) /
      (math.max(graph:get_peak(), matchGraph.graph:get_peak()) * 1.2)
end

function playerGraph.setSnap(k)
   local val = math.floor(graph["get_"..k](graph) + 0.5)
   val = math.max(minLimits[k], math.min(maxLimits[k], val))
   graph:snapTo(k, val)
end

function playerGraph.setIncr(k, bool)
   doIncr[k] = bool
   if bool then
      doDecr[k] = false
   elseif love.keyboard.isDown(km["decr_"..k]) then
      doDecr[k] = true
   else
      playerGraph.setSnap(k)
   end
end

function playerGraph.setDecr(k, bool)
   doDecr[k] = bool
   if bool then
      doIncr[k] = false
   elseif love.keyboard.isDown(km["incr_"..k]) then
      doIncr[k] = true
   else
      playerGraph.setSnap(k)
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
	 graph:incrSpeed(k)

      elseif doDecr[k] then
	 graph:decrSpeed(k)
      end
   end

   playerGraph.scale = playerGraph.getScale()
   graph:set_scale(playerGraph.scale)
   graph:update(dt)
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
   love.graphics.setFont(debugFont)
   love.graphics.print(
      "a:\t" .. graph:get_a()
	 .. "\nb:\t" .. graph:get_b()
	 .. "\nn:\t" .. graph:get_n(),
      5, 5
   )
   --EOF DEBUG
end
