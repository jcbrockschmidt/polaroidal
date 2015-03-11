--require "playerGraph"
--require "polar"

matchGraph = {}

matchGraph.graph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0, 50,
      4, 1, 5
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

   diff = math.abs(playerGraph.graph:get_b() - graph:get_b())
   if diff > fuzz.b then
      return false
   end

   diff = math.abs(playerGraph.graph:get_n() - graph:get_n())
   if diff > fuzz.n then
      return false
   end

   return true
end

function matchGraph.update(dt)
   --DEBUGGING
   MATCHING = matchGraph.graphsMatch()
   --EOF DEBUGGING
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
   
   if MATCHING then
      love.graphics.setColor(0, 200, 0, 255)
      love.graphics.print(
	 "\n\n\n\n\n\nMATCHING",
	 5, 5
      )
   else
      love.graphics.setColor(200, 0, 0, 255)
      love.graphics.print(
	 "\n\n\n\n\n\nNOT MATCHING",
	 5, 5
      )
   end	 
   --EOF DEBUG
end
