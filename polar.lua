local graph = {
   maxSpeeds = {
      a = 12,
      b = 12,
      n = 12
   },

   accels = {
      a = 30,
      b = 30,
      n = 24
   },

   fricts = {
      a = -12,
      b = -12,
      n = -12
   },

   snap = {
      a = 0,
      b = 0,
      n = 0
   },

   snapFuzz = {
      a = 0.05,
      b = 0.05,
      n = 0.05,
   },

   snapSpeedFuzz = {
      a = 0.5,
      b = 0.5,
      n = 0.1
   },

   --- Calculates cartesian points for a given polarized graph object.
   -- @param self  Polarized graph object.
   -- @param scale  Number. Scale of graph. Will augment radius.
   calcPoints = function(self)
      self.points = {}
      self.peak = 0
      local angle, r
      for p = 1, polar.maxPoints + 1 do
	 angle = polar.angleIncr * p
	 r = (self.a + (self.b * math.sin(self.n * (angle + self.rads))))
	 table.insert(self.points, -(r * self.scale * math.cos(angle)) + self.x)
	 local y = r * math.sin(angle)
	 table.insert(self.points, -y * self.scale + self.y)

	 if math.abs(y) > self.peak then
	    self.peak = math.abs(y)
	 end
      end
   end,

   setSpeed = function(self, k, speed)
      self.speeds[k] = math.max(-self.maxSpeeds[k], math.min(self.maxSpeeds[k], speed))
   end,

   getSpeed = function(self, k)
      return self.speeds[k]
   end,

   incrSpeed = function(self, k)
      self.doIncr[k] = true
      self.doDecr[k] = false
   end,

   decrSpeed= function(self, k)
      self.doDecr[k] = true
      self.doIncr[k] = false
   end,

   cancelChanges = function(self, k)
      self.doIncr[k] = false
      self.doDecr[k] = false
   end,

   update = function(self, dt)
      local pars = {
	 a = self.a,
	 b = self.b,
	 n = self.n
      }

      for k, v in pairs(pars) do
	 if self.speeds[k] > 0 then
	    self.speeds[k] = math.max(0, self.speeds[k] + self.fricts[k] * dt)
	 elseif self.speeds[k] < 0 then
	    self.speeds[k] = math.min(0, self.speeds[k] - self.fricts[k] * dt)
	 end

	 if self.doIncr[k] then
	    self.speeds[k] = math.min(
	       self.maxSpeeds[k],
	       self.speeds[k] + self.accels[k] * dt
	    )
	    self.doIncr[k] = false

         elseif self.doDecr[k] then
	    self.speeds[k] = math.max(
	       -self.maxSpeeds[k],
	       self.speeds[k] - self.accels[k] * dt
	    )
	    self.doDecr[k] = false

         elseif self.snap[k] then
	    if math.abs(self.snap[k] - v) > self.snapFuzz[k] or
	    math.abs(self.speeds[k]) > self.snapSpeedFuzz[k] then
	       if v > self.snap[k] then
		  self.speeds[k] = math.max(
		     -self.maxSpeeds[k],
		     self.speeds[k] - self.accels[k] * dt
		  )

	       elseif v < self.snap[k] then
		  self.speeds[k] = math.min(
		     self.maxSpeeds[k],
		     self.speeds[k] + self.accels[k] * dt
		  )
	       end

	    else
	       self.speeds[k] = 0
	       pars[k] = self.snap[k]
	    end

	 elseif math.abs(self.speeds[k]) < 0.01 then
	    self.speeds[k] = 0
	 end

	 self["set_"..k](self, math.max(
			    -self.maxSpeeds[k],
			    math.min(self.maxSpeeds[k], pars[k] + self.speeds[k] * dt)
			))
      end
   end,

   snapTo = function(self, k, val)
      self.snap[k] = val
   end,

   cancelSnap = function(self, k)
      self.snap[k] = false
   end,

   halt = function(self, k)
      self:cancelSnap(k)
      self:setSpeed(k, 0)
   end,

   get_peak = function(self)
      return self.peak
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
      self.rads = rads
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
	 speeds = {
	    a = 0,
	    b = 0,
	    n = 0
	 },
	 doIncr = {
	    a = false,
	    b = false,
	    n = false
	 },
	 doDecr = {
	    a = false,
	    b = false,
	    n = false
	 },
	 snap = {
	    a = false,
	    b = false,
	    n = false
	 },
	 points = {}
      }
      setmetatable(obj, mt)
      obj:calcPoints()
      return obj
   end
}

polar.angleIncr = math.pi / 128
polar.maxPoints = math.floor(2 * math.pi / polar.angleIncr)

setmetatable(polar, mt)
