--DOIT:
-- * Add effect for when menu buttons come in and come out when a tab is
--   opened or close.
-- * Fix menu going out. Buttons and dividers just disappear
--   without a transition.

menu = {}

function menu.load()
   buttonSet.btn_h = fonts.menu:getHeight(" ") + 6

   menu.buttonSets = {
      buttonSet.new(),
      buttonSet.new(),
      buttonSet.new()
   }

   -- Start menu
   menu.buttonSets[1]:addButton(
      "Play",
      function()
	 menu.waitForMenu(
	    function ()
	       menu.curButtonSet = menu.buttonSets[2]
	       menu.curButtonSet:selectButton(1)
	       menu.curButtonSet:comeIn()
	    end )
      end )
   menu.buttonSets[1]:addButton("Options", function() return end)
   menu.buttonSets[1]:addButton("Credits", function() return end)
   menu.buttonSets[1]:addButton(
      "Exit",
      function()
	 menu.waitForMenu(menu.close, {love.event.quit})
      end )

   -- Gamemodes
   menu.buttonSets[2]:addButton(
      "Challenge",
      function()
	 menu.waitForMenu(menu.close, {game.new, "challenge"})
      end )
   menu.buttonSets[2]:addButton(
      "Timed",
      function()
	 menu.waitForMenu(
	    function()
	       menu.curButtonSet = menu.buttonSets[3]
	       menu.curButtonSet:selectButton(1)
	       menu.curButtonSet:comeIn()
	    end )
      end )
   menu.buttonSets[2]:addButton(
      "Casual",
      function()
	 menu.waitForMenu(menu.close, {game.new, "casual"})
      end )
   menu.buttonSets[2]:setBack(
      function()
	 menu.waitForMenu(
	    function()
	       menu.curButtonSet = menu.buttonSets[1]
	       menu.curButtonSet:selectButton(1)
	       menu.curButtonSet:comeIn()
	    end )
      end )

   -- Timed games
   menu.buttonSets[3]:addButton(
      "5 minutes",
      function()
	 menu.waitForMenu(menu.close, {game.new, "timed", 300})
      end )
   menu.buttonSets[3]:addButton(
      "3 minutes",
      function()
	 menu.waitForMenu(menu.close, {game.new, "timed", 180})
      end )
   menu.buttonSets[3]:addButton(
      "1 minute",
      function()
	 menu.waitForMenu(menu.close, {game.new, "timed", 60})
      end )
   menu.buttonSets[3]:setBack(
      function()
	 menu.waitForMenu(
	    function()
	       menu.curButtonSet = menu.buttonSets[2]
	       menu.curButtonSet:selectButton(2)
	       menu.curButtonSet:comeIn()
	    end )
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
   menu.waitForMenu_bool = false
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

   menu.curButtonSet:comeIn()
end

function menu.waitForMenu(func, args)
   menu.curButtonSet:goOut()
   menu.waitForMenu_bool = true
   menu.waitForMenu_func = func
   menu.waitForMenu_args = args
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
   menu.curButtonSet:update(dt)
   if menu.waitForMenu_bool then
      if menu.curButtonSet.isOut then
	 menu.waitForMenu_bool = false
	 menu.waitForMenu_func(unpack(menu.waitForMenu_args or {}))
      end
   end

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

   elseif key == "backspace" or key == "escape" or key == "b" or
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
	 menu.closingSigns[g][par] = (menu.graphs[g]["get_"..par](menu.graphs[g]) > 0)
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
   spacer_h = 6,
   selectColor = {0, 0, 255, 255},
   regularColor = {200, 200, 255, 255},
   divColor = {100, 100, 255, 255},

   btn_x_goal = 28,
   div_x_goal = 20,
   inOutAccel = 700,
   seperate_x = 50,

   new = function()
      local obj = {
	 buttons = {},
	 curBtn = 0,
	 divs_x = {},
	 isIn = false,
	 isOut = true,
	 comingIn = false,
	 goingOut = false,
	 resting_x = 0
      }
      setmetatable(obj, buttonSet_mt)

      return obj
   end,

   addButton = function(self, text, func)
      table.insert(
	 self.buttons,
	 {text = text, func = func, speed = 0}
      )
      local bNum = #self.buttons
      local w = fonts.menu:getWidth(text)
      if bNum > 1 then
	 -- Add divider before new button.
	 table.insert(
	    self.divs_x,
	    {x = self.div_x_goal, speed = 0}
	 )
	 w = math.max(
	    self.div_x_goal + self.seperate_x, --New divider
	    w --New button.
	 )
      end

      -- Determine if resting position for button set needs to be changed
      local rt_x = self.resting_x - self.seperate_x * (bNum-1)*2 + w
      local changedRest = false
      if rt_x > 0 then
	 self.resting_x = self.resting_x - rt_x
	 changedRest = true
      end

      if self.isOut or self.goingOut then
	 if changedRest then
	    -- Update all resting positions
	    for bNum, btn in ipairs(self.buttons) do
	       btn.x = self.resting_x - self.seperate_x * (bNum-1)*2
	       if bNum < #self.buttons then
		  self.divs_x[bNum].x = self.resting_x - self.seperate_x * (bNum*2-1)
	       end
	    end
	 else
	    -- Just update new divider's (if exists) and new button's
	    -- resting positions
	    if bNum > 1 then
	       self.divs_x[bNum-1].x =
		  self.resting_x - self.seperate_x * (bNum*2-3)
	    end
	    self.buttons[bNum].x =
	       self.resting_x - self.seperate_x * (bNum-1)*2
	 end
      elseif self.isIn or self.comingIn then
	 -- Change new divider's (if exists) and new button's positions
	 -- to their optimals/goals
	 local bNum = #self.buttons
	 if bNum > 1 then
	    self.divs_x[bNum-1].x = self.div_x_goal
	 end
	 self.buttons[bNum].x = self_btn_x_goal
      end
      --DOIT: Determine new x-coordinates of divider and buttons
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

   comeIn = function(self)
      if self.isIn then
	 return
      end
      self.isIn = false
      self.isOut = false
      self.goingOut = false
      self.comingIn = true
   end,

   goOut = function(self)
      if self.isOut then
	 return
      end
      self.isIn = false
      self.comingIn = false
      self.isOut = false
      self.goingOut = true
   end,

   update = function(self, dt)
      if self.comingIn or self.goingOut then
	 local isDone = true
	 local accel
	 local btn_x_goal
	 local div_x_goal
	 local seperate_x
	 if self.comingIn then
	    accel = self.inOutAccel
	    btn_x_goal = self.btn_x_goal
	    div_x_goal = self.div_x_goal
	    seperate_x = 0
	 elseif self.goingOut then
	    accel = -self.inOutAccel
	    btn_x_goal = self.resting_x
	    div_x_goal = self.resting_x
	    seperate_x = self.seperate_x
	 end
	 for bNum, btn in ipairs(self.buttons) do
	    local goal = btn_x_goal - seperate_x * (bNum-1)*2
	    if btn.x ~= goal then
	       if math.abs(predictIncr(btn.speed, accel)) <
	       math.abs(goal - btn.x) then
		  btn.speed = btn.speed + accel*dt
	       else
		  btn.speed = btn.speed - accel*dt
	       end
	       btn.x = btn.x + btn.speed*dt
	       if (self.comingIn and btn.x >= goal) or
	       (self.goingOut and btn.x <= goal) then
		  btn.x = goal
		  btn.speed = 0
	       else
		  isDone = false
	       end
	    end
	    if bNum < #self.buttons then
	       local goal = div_x_goal - seperate_x * (bNum*2-1)
	       div = self.divs_x[bNum]
	       if div.x ~= goal then
		  if math.abs(predictIncr(div.speed, accel)) <
		  math.abs(goal - div.x) then
		     div.speed = div.speed + accel*dt
		  else
		     div.speed = div.speed - accel*dt
		  end
		  div.x = div.x + div.speed*dt
		  if (self.comingIn and div.x >= goal) or
		  (self.goingOut and div.x <= goal) then
		     div.x = goal
		     div.speed = 0
		  else
		     isDone = false
		  end
	       end
	    end
	 end
	 if isDone then
	    if self.comingIn then
	       self.comingIn = false
	       self.isIn = true
	    elseif self.goingOut then
	       self.goingOut = false
	       self.isOut = true
	    end
	 end
      end
   end,

   draw = function(self)
      if self.isOut then
	 -- Don't draw anything if it's all supposed to be off screen
	 return
      end

      love.graphics.setFont(fonts.menu)
      local y = self.dy
      for bNum, btn in ipairs(self.buttons) do
	 -- Draw button
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
	    btn.x, y
	 )

	 if bNum < #self.buttons then
	    -- Draw dividing lines
	    y = y + self.btn_h
	    love.graphics.setColor(self.divColor)
	    love.graphics.rectangle(
	       "fill",
	       self.divs_x[bNum].x, y,
	       self.div_w, self.div_h
	    )
	    y = y + self.div_h + self.spacer_h
	 end
      end
   end
}
buttonSet_mt.__index = buttonSet
