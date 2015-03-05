local incr = math.pi / 128
local maxPoints = math.floor(2 * math.pi / incr)
local twoPi = 2 * math.pi

local graph = {
   --- Calculates cartesian points for a given polarized graph object.
   -- @param self  Polarized graph object.
   -- @param scale  Number. Scale of graph. Will augment radius.
   calcPoints = function(self)
      self.points = {}
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

   get_x = function(self)
      return self.x
   end,

   get_y = function(self)
      return self.y
   end,

   get_rads = function(self)
      return self.rads
   end,

   get_scale = function(self)
      return self.scale
   end,

   get_a = function(self)
      return self.a
   end,

   get_b = function(self)
      return self.b
   end,

   get_n = function(self)
      return self.n
   end,
   
   set_x = function(self, x)
      self.x = x
   end,

   set_y = function(self, y)
      self.y = y
   end,

   set_rads = function(self, rads)
      -- Ensure radians are within domain [0, 2*pi).
      self.rads = rads - math.floor(rads / twoPi) * twoPi
   end,

   set_scale = function(self, scale)
      self.scale = scale
   end,

   set_a = function(self, a)
      self.a = a
   end,

   set_b = function(self, b)
      self.b = b
   end,

   set_n = function(self, n)
      self.n = n
   end,

   --- Draws a polarized graph object.
   -- @param self  Polarized graph object.
   -- @param lineThickness  Number. In pixels.
   draw = function(self, lineThickness)
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
