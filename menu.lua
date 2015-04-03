menu = {}

function menu.load()
   buttonSet.btn_h = fonts.menu:getHeight(" ") + 6

   menu.buttonSets = {
      buttonSet.new(),
      buttonSet.new()
   }
   menu.buttonSets[1]:addButton(
      "Play",
      function()
	 menu.curButtonSet = menu.buttonSets[2]
	 menu.curButtonSet:selectButton(1)
      end )
   menu.buttonSets[1]:addButton("Options", function() return end)
   menu.buttonSets[1]:addButton("Credits", function() return end)
   menu.buttonSets[1]:addButton(
      "Exit",
      function()
	 menu.close(love.event.quit)
      end )
   menu.buttonSets[2]:addButton(
      "Challenge",
      function()
	 menu.close(newGame, "challenge")
      end )
   menu.buttonSets[2]:addButton(
      "Timed",
      function()
	 menu.close(newGame, "timed")
      end )
   menu.buttonSets[2]:addButton(
      "Casual",
      function()
	 menu.close(newGame, "casual")
      end )
   menu.buttonSets[2]:setBack(
      function ()
	 menu.curButtonSet = menu.buttonSets[1]
	 menu.curButtonSet:selectButton(1)
      end )

   menu.curButtonSet = menu.buttonSets[1]
   menu.curButtonSet:selectButton(1)

   menu.graphScale = 27
   menu.graphThicknesses = {10, 5}
   menu.graphColors = {
      {200, 200, 200, 255},
      {0, 0, 127, 255}
   }
   menu.graphs = {}

   menu.graphs[1] = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0, menu.graphScale, 0, 0, 0)

   menu.graphs[2] = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0, menu.graphScale, 0, 0, 0)

   menu.maxRads = math.pi
   menu.radAccel = 0.002
   menu.maxRadSpeed = 0.01
   menu.radSpeeds = {}
   -- Indices correspond with graph numbers
   -- If value is true, graph's rads will increase
   -- If value is false, graph's rads will decrease
   menu.radsIncr = {}

   -- Used while closing menu
   -- Indices correspond with graph numbers
   -- Values are tables whose indices are 'a', 'b' and 'n', all graph parameters
   menu.closingSigns = {{}, {}}

   -- Used while closing menu
   -- Indices correspond with graph numbers
   -- Values are tables whose indices are 'a', 'b' and 'n', all graph parameters
   -- True if the graph has closed, false otherwise
   menu.closed = {{}, {}}

   menu.reload()
end

function menu.reload()
   menu.isClosing = false
   menu.canSelect = true
   for _, par in pairs({"a", "b", "n"}) do
      menu.closed[1][par] = false
      menu.closed[2][par] = false
   end
   menu.radSpeeds[1] = 0
   menu.radSpeeds[2] = 0
   menu.radsIncr[1] = true
   menu.radsIncr[2] = true
   menu.graphs[1]:set_rads(math.pi/4)
   menu.graphs[2]:set_rads(0)
   menu.shuffleGraphPoints()
end

function menu.shuffleGraphPoints()
   local pars = {
      a = menu.graphs[1]:get_a(),
      b = menu.graphs[1]:get_b(),
      n = menu.graphs[1]:get_n()
   }

   -- Make sure the sign of a is flipped (positive->negative, negative->positive)
   if pars.a > 0 then
      pars.a = math.random(playerGraph.minLimits.a, -1)
   else
      pars.a = math.random(1, playerGraph.maxLimits.a)
   end

   local new = math.random(playerGraph.minLimits.b, playerGraph.maxLimits.b - 1)
   if new > pars.b then
      new = new + 1
   end
   pars.b = new

   new = math.random(playerGraph.minLimits.n, playerGraph.maxLimits.n - 1)
   if new > pars.n then
      new = new + 1
   end
   pars.n = new

   for k, v in pairs(pars) do
      menu.graphs[1]:snapTo(k, v)
      menu.graphs[2]:snapTo(k, v)
   end
end

function menu.update(dt)
   for k, graph in ipairs(menu.graphs) do
      local rads = graph:get_rads()

      if menu.radsIncr[k] then
	 menu.radSpeeds[k] = math.min(
	    menu.maxRadSpeed,
	    menu.radSpeeds[k] + menu.radAccel * dt
	 )
	 rads = rads + menu.radSpeeds[k]
	 if rads > menu.maxRads then
	    menu.radsIncr[k] = false
	 end
      else
	 menu.radSpeeds[k] = math.max(
	    -menu.maxRadSpeed,
	    menu.radSpeeds[k] - menu.radAccel * dt
	 )
	 rads = rads + menu.radSpeeds[k]
	 if rads < -menu.maxRads then
	    menu.radsIncr[k] = true
	 end
      end

      graph:set_rads(rads)
      graph:update(dt)
      graph:calcPoints()
   end

   if menu.isClosing then
      closed = true

      for g = 1, 2 do
	 for _, par in pairs({"a", "b", "n"}) do
	    if not menu.closed[g][par] then
	       -- If parameter was positive when closing initiated
	       if menu.closingSigns[g][par] then
		  if menu.graphs[g]["get_"..par](menu.graphs[g]) <= 0 then
		     menu.graphs[g]:halt(par)
		     menu.graphs[g]["set_"..par](menu.graphs[g], 0)
		     menu.closed[g][par] = true
		  else
		     closed = false
		  end

	       -- If parameter was negative when closing initiated
	       else
		  if menu.graphs[g]["get_"..par](menu.graphs[g]) >= 0 then
		     menu.graphs[g]:halt(par)
		     menu.graphs[g]["set_"..par](menu.graphs[g], 0)
		     menu.closed[g][par] = true
		  else
		     closed = false
		  end
	       end
	    end
	 end
      end

      if closed then
	 menu.closingFunc(unpack(menu.closingArgs))
      end
   end
end

function menu.keypressed(key)
   if not menu.canSelect then
      return
   end

   if key == "w" or key == "i" or key == "up" then
      newBtn = menu.curButtonSet.curBtn - 1
      if newBtn < 1 then
	 newBtn = #menu.curButtonSet.buttons
      end
      menu.curButtonSet:selectButton(newBtn)

   elseif key == "s" or key == "k" or key == "down" then
      newBtn = menu.curButtonSet.curBtn + 1
      if newBtn > #menu.curButtonSet.buttons then
	 newBtn = 1
      end
      menu.curButtonSet:selectButton(newBtn)

   elseif key == " " or key == "return" or
   key == "d" or key == "l" or key == "right" then
      menu.curButtonSet:activate()

   elseif key == "backspace" or key == "b" or
   key == "a" or key == "j" or key == "left" then
      menu.curButtonSet:goBack()
   end
end

function menu.draw()
   for gNum, graph in ipairs(menu.graphs) do
      love.graphics.setColor(menu.graphColors[gNum])
      graph:draw(menu.graphThicknesses[gNum])
   end
   menu.curButtonSet:draw()
end

-- Does closing effect for menu and calls the given callback (cb) with the
-- given arguments (...) when it finishes
function menu.close(cb, ...)
   menu.isClosing = true
   menu.canSelect = false
   menu.closingFunc = cb
   menu.closingArgs = {...}
   for g = 1, 2 do
      for _, par in ipairs({"a", "b", "n"}) do
	 menu.graphs[g]:snapTo(par, 0)
	 if menu.graphs[g]["get_"..par](menu.graphs[g]) > 0 then
	    menu.closingSigns[g][par] = true
	 else
	    menu.closingSigns[g][par] = false
	 end
	 menu.closed[g][par] = false
      end
   end
end

local buttonSet_mt = {}
buttonSet = {
   dx = 20,
   dy = 20,
   selector_x = 10,
   btn_h = 0, --> Will be set in menu.load()
   div_h = 4,
   div_w = 150,
   spacer_w = 8,
   spacer_h = 6,
   selectColor = {0, 0, 255, 255},
   regularColor = {200, 200, 255, 255},
   divColor = {100, 100, 255, 255},

   new = function()
      local obj = {
	 buttons = {},
	 curBtn = 0
      }
      setmetatable(obj, buttonSet_mt)

      return obj
   end,

   addButton = function(self, text, func)
      table.insert(
	 self.buttons,
	 {
	    text = text,
	    func = func,
	 }
      )
   end,

   selectButton = function(self, bNum)
      self.curBtn = bNum
   end,

   ifSelected = function(self, bNum)
      return bNum == self.curBtn
   end,

   activate = function(self)
      self.buttons[self.curBtn].func()
      if not menu.isClosing then
	 menu.shuffleGraphPoints()
      end
   end,

   setBack = function(self, func)
      self.backFunc = func
   end,

   goBack = function(self)
      if self.backFunc then
	 self.backFunc()
      end
      menu.shuffleGraphPoints()
   end,

   draw = function(self)
      love.graphics.setFont(fonts.menu)
      local x = self.dx + self.spacer_w
      local y = self.dy
      for bNum, btn in ipairs(self.buttons) do
	 if bNum == self.curBtn then
	    love.graphics.setColor(self.selectColor)
	    love.graphics.print(
	       ">",
	       self.selector_x, y
	    )
	 else
	    love.graphics.setColor(self.regularColor)
	 end
	 love.graphics.print(
	    btn.text,
	    x, y
	 )
	 if bNum < #self.buttons then
	    y = y + self.btn_h
	    love.graphics.setColor(self.divColor)
	    love.graphics.rectangle(
	       "fill",
	       self.dx, y,
	       self.div_w, self.div_h
	    )
	    y = y + self.div_h + self.spacer_h
	 end
      end
   end
}
buttonSet_mt.__index = buttonSet
