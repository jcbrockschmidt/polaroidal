local data = {}

timers = {
       new = function(t, cb)
	  tID = #data + 1
	  data[tID] = {
	     t = t,
	     cb = cb
	  }
       end,

       del = function(tID)
	  data[tID] = nil
       end,

       clearAll = function()
	  data = {}
       end,

       update = function(dt)
	  for tID, tmr in pairs(data) do
	     tmr.t = tmr.t - dt
	     if tmr.t <= 0 then
		if tmr.cb then
		   tmr.cb()
		end

		timers.del(tID)
	     end
	  end
       end
}
