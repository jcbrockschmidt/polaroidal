--require "playerGraph"
--require "polar"

matchGraph = {}

matchGraph.graph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0, 50,
      2, -4, 1
)

-- When checking if this and the player's polar graph's match, this is how
-- much lenience will be granted for each parameter. The absolute difference
-- between each of the player's parameters must be less than or equal to it's
-- "fuzz," respectively.
matchGraph.fuzz = {
   a = .2,
   b = .3,
   n = .2,
}

local graph = matchGraph.graph
local fuzz = matchGraph.fuzz

function matchGraph.load()
   return --> PLACEHOLDER
end

function matchGraph.graphsMatch()
   local diff = math.abs(
      math.abs(playerGraph.graph:get_a()) - math.abs(graph:get_a())
   )
   if diff > fuzz.a then
      return false
   end

   local p_b, p_n = playerGraph.graph:get_b(), playerGraph.graph:get_n()
   local m_b, m_n = graph:get_b(), graph:get_n()

   -- Account for case in which one graph's b AND n are negative value of the
   -- other's. If this is the case, the graph's will still visually align
   -- (assuming the a value is also aligned).
   if ((p_b > 0 and m_b < 0) or (p_b < 0 and m_b > 0)) or
   ((p_n > 0 and m_n < 0) or (p_n < 0 and m_n > 0)) then
      if math.abs(math.abs(p_b) - math.abs(m_b)) > fuzz.b then
	 return false
      end

      if math.abs(math.abs(p_n) - math.abs(m_n)) > fuzz.n then
	 return false
      end

   else
      if math.abs(p_b - m_b) > fuzz.b then
	 return false
      end

      if math.abs(p_n - m_n) > fuzz.n then
	 return false
      end
   end

   return true
end

function matchGraph.shuffleGraph()
   local polarPars = {
      a = graph:get_a(),
      b = graph:get_b(),
      n = graph:get_n()
   }

   for k, v in pairs(polarPars) do
      local new = math.random(playerGraph.minLimits[k], playerGraph.maxLimits[k] - 1)
      -- Ensure that new value actually changes.
      if new > v then
	 new = new + 1
      end
      graph["set_"..k](graph, new)
   end

   graph:calcPoints()
end

function matchGraph.update(dt)
   if matchGraph.graphsMatch() then
      matchGraph.shuffleGraph()
   end
end

function matchGraph.draw()
   love.graphics.setColor(200, 200, 200, 255)
   graph:draw(5)
   
   --DEBUGGING
   love.graphics.setColor(200, 0, 0, 255)
   love.graphics.print(
      "\n\n\na:\t" .. graph:get_a()
	 .. "\nb:\t" .. graph:get_b()
	 .. "\nn:\t" .. graph:get_n(),
      5, 5
   )
   --EOF DEBUG
end
