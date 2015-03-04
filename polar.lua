local incr = math.pi / 64
local maxPoints = math.floor(2 * math.pi / incr)
local lineThickness = 4

local graph = {
   --- Calculates cartesian points for a given polarized graph object.
   -- @param self  Polarized graph object.
   -- @param scale  Number. Scale of graph. Will augment radius.
   calcPoints = function(self)
      local angle, r
      for p = 1, maxPoints do
	 angle = incr * p
	 r = (self.a + (self.b * math.sin(self.n * (angle + self.rads)))) * self.scale
	 table.insert(self.points, (r * math.cos(angle)) + self.x)
	 table.insert(self.points, (r * math.sin(angle)) + self.y)
      end
      table.insert(self.points, self.points[1])
      table.insert(self.points, self.points[2])
   end,

   --- Draws a polarized graph object.
   -- @param self  Polarized graph object.
   draw = function(self)
      love.graphics.setLineWidth(lineThickness)
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
   -- @param rads  Number [0, 2*pi].
   -- @param scale  Number. Radius will be augmented to shrunken according to
   --  this number when graph's points are calculated.
   -- @param a  Number.
   -- @param b  Number (0, oo).
   -- @param n  Number.
   -- @return  A polarized graph object.
   new = function(x, y, rads, scale, a, b, n)
      local obj = {
	 x = x,
	 y = y,
	 rads = rads or 0,
	 scale = scale or 1,
	 a = a or 0,
	 b = b or 1,
	 n = n or 1,
	 points = {}
      }
      setmetatable(obj, mt)
      obj:calcPoints()
      return obj
   end
}

setmetatable(polar, mt)
