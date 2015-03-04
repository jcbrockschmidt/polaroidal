local incr = math.pi / 6
local maxPoints = math.floor(2 * math.pi / incr)

local graph = {
   --- Calculates cartesian points for a given polarized graph object.
   -- @param self  Polarized graph object.
   calcPoints = function(self)
      local angle
      for p = 1, maxPoints do
	 angle = incr * p
	 table.insert(self.points, (self.r * math.cos(angle)) + self.x)
	 table.insert(self.points, (self.r * math.sin(angle)) + self.y)
      end
      table.insert(self.points, self.points[1])
      table.insert(self.points, self.points[2])
   end,

   --- Draws a polarized graph object.
   -- @param self  Polarized graph object.
   draw = function(self)
      love.graphics.line(unpack(self.points))
   end
}

local mt = {
   __index = graph
}

polar = {
   --- Creates a new polarized graph.
   -- @param x  Number. X-coordinate of graph's origin.
   -- @param y  Number. Y-coordinate of graph's origin.
   -- @return  A polarized graph object.
   new = function(x, y, r)
      local obj = {
	 x = x,
	 y = y,
	 r = r,
	 points = {}
      }
      local angle
      setmetatable(obj, mt)
      obj:calcPoints()
      return obj
   end,
   
   draw = graph.draw
}
