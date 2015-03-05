require "polar"

playerGraph = {}

playerGraph.graph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0,
      50,
      2, 3, 10
)

playerGraph.keyMaps = {
   incr_a = "i",
   decr_a = "k",
   incr_b = "m",
   decr_b = ".",
   incr_n = "u",
   decr_n = "o",
   incr_rads = "l",
   decr_rads = "j"
}

playerGraph.doIncr = {}

playerGraph.doDecr = {}

playerGraph.speeds = {}

playerGraph.maxSpeeds = {
   a = 3,
   b = 3,
   n = 3,
   rads = 3
}

playerGraph.accels = {
   a = 2,
   b = 2,
   n = 2,
   rads = 2
}

playerGraph.fricts = {
   a = -1,
   b = -1,
   n = -1,
   rads = -1
}

local graph = playerGraph.graph
local km = playerGraph.keyMaps
local doIncr = playerGraph.doIncr
local doDecr = playerGraph.doDecr
local speeds = playerGraph.speeds
local maxSpeeds = playerGraph.maxSpeeds
local accels = playerGraph.accels
local fricts = playerGraph.fricts

function playerGraph.load()
   for _, k in pairs({"a", "b", "n", "rads"}) do
      doIncr[k] = false
      doDecr[k] = false
      speeds[k] = 0
   end
end

function playerGraph.update(dt)
   for k, s in pairs(speeds) do
      if s > 0 then
	 speeds[k] = math.max(0, s + fricts[k] * dt)
      elseif s < 0 then
	 speeds[k] = math.min(0, s - fricts[k] * dt)
      end
   end

   if doIncr.a then
      speeds.a = math.min(maxSpeeds.a, speeds.a + accels.a * dt)
   elseif doDecr.a then
      speeds.a = math.max(-maxSpeeds.a, speeds.a - accels.a * dt)
   end

   if doIncr.b then
      speeds.b = math.min(maxSpeeds.b, speeds.b + accels.b * dt)
   elseif doDecr.b then
      speeds.b = math.max(-maxSpeeds.b, speeds.b - accels.b * dt)
   end

   if doIncr.n then
      speeds.n = math.min(maxSpeeds.n, speeds.n + accels.n * dt)
   elseif doDecr.n then
      speeds.n = math.max(-maxSpeeds.n, speeds.n - accels.n * dt)
   end

   if doIncr.rads then
      speeds.rads = math.min(maxSpeeds.rads, speeds.rads + accels.rads * dt)
   elseif doDecr.rads then
      speeds.rads = math.max(-maxSpeeds.rads, speeds.rads - accels.rads * dt)
   end

   graph:set_a(graph:get_a() + speeds.a * dt)
   graph:set_b(graph:get_b() + speeds.b * dt)
   graph:set_n(graph:get_n() + speeds.n * dt)
   graph:set_rads(graph:get_rads() + speeds.rads * dt)

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

   elseif key == km.incr_rads then
      doIncr.rads = true
      doDecr.rads = false
   elseif key == km.decr_rads then
      doDecr.rads = true
      doIncr.rads = false
   end
end

function playerGraph.keyreleased(key)
   if key == km.incr_a then
      doIncr.a = false
      if love.keyboard.isDown(km.decr_a) then
	 doDecr.a = true
      else
	 doDecr.a = false
      end
   elseif key == km.decr_a then
      doDecr.a = false
      if love.keyboard.isDown(km.incr_a) then
	 doIncr.a = true
      else
	 doIncr.a = false
      end

   elseif key == km.incr_b then
      doIncr.b = false
      if love.keyboard.isDown(km.decr_b) then
	 doDecr.b = true
      else
	 doDecr.b = false
      end
   elseif key == km.decr_b then
      doDecr.b = false
      if love.keyboard.isDown(km.incr_b) then
	 doIncr.b = true
      else
	 doIncr.b = false
      end

   elseif key == km.incr_n then
      doIncr.n = false
      if love.keyboard.isDown(km.decr_n) then
	 doDecr.n = true
      else
	 doDecr.n = false
      end
   elseif key == km.decr_n then
      doDecr.n = false
      if love.keyboard.isDown(km.incr_n) then
	 doIncr.n = true
      else
	 doIncr.n = false
      end

   elseif key == km.incr_rads then
      doIncr.rads = false
      if love.keyboard.isDown(km.decr_rads) then
	 doDecr.rads = true
      else
	 doDecr.rads = false
      end
   elseif key == km.decr_rads then
      doDecr.rads = false
      if love.keyboard.isDown(km.incr_rads) then
	 doIncr.rads = true
      else
	 doIncr.rads = false
      end
   end
end

function playerGraph.draw()
   love.graphics.setColor(0, 0, 127, 255)
   graph:draw(5)
end
