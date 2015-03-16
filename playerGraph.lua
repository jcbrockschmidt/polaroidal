--DOIT: account for graph limits

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
   for _, k in pairs({"a", "b", "n"}) do
      doIncr[k] = false
      doDecr[k] = false
   end
end

function playerGraph.getSnap(k)
   graph:snapTo(k, math.floor(graph["get_"..k](graph) + 0.5))
   print(math.floor(graph["get_"..k](graph) + 0.5))
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
	 graph:incrSpeed(k)

      elseif doDecr[k] then
	 graph:decrSpeed(k)
      end
   end

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
   love.graphics.print(
      "a:\t" .. graph:get_a()
	 .. "\nb:\t" .. graph:get_b()
	 .. "\nn:\t" .. graph:get_n(),
      5, 5
   )
   --EOF DEBUG
end
