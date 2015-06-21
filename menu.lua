--DOIT:
-- * Menu elements continue toward goal until new goal is set.
--   Elements will probably have to store their own goal.

menu = {}

function menu.load()
   buttonSet.btn_h = fonts.menu:getHeight(" ") + 6

   menu.highscores = {
      rect = {
	 color = {200, 200, 200, 255},
	 y = 20,
	 w = 400,
	 h = love.graphics.getHeight() - 40,
	 x_out = love.graphics.getWidth(),
	 x_in = love.graphics.getWidth() - 420,
	 x_accel = 1500
      },
      comeIn = function()
	 menu.highscores.isIn = false
	 menu.highscores.comingIn = true
	 menu.highscores.goingOut = false
	 menu.highscores.update_bool = true
	 menu.highscores.draw_bool = true
	 menu.curButtonSet = false
      end,
      goOut = function()
	 menu.highscores.isIn = false
	 menu.highscores.comingIn = false
	 menu.highscores.goingOut = true
      end
   }

   menu.buttonSets = {
      buttonSet.new(), --Main Menu
      buttonSet.new(), --Gamemodes
      buttonSet.new()  --Timed Gamemodes
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
   menu.buttonSets[1]:addButton(
      "Highscores",
      function()
	 menu.waitForMenu(menu.highscores.comeIn)
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
      "15 minutes",
      function()
	 menu.waitForMenu(menu.close, {game.new, "timed", 900})
      end )
   menu.buttonSets[3]:addButton(
      "5 minutes",
      function()
	 menu.waitForMenu(menu.close, {game.new, "timed", 300})
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

   menu.keyCheck = {
      up = function(key)
	 if key == "w" or key == "i" or key == "up" then
	    return true
	 else
	    return false
	 end
      end,
      down = function(key)
	 if key == "s" or key == "k" or key == "down" then
	    return true
	 else
	    return false
	 end
      end,
      enter = function(key)
	 if key == " " or key == "return" or
	 key == "d" or key == "l" or key == "right" then
	    return true
	 else
	    return false
	 end
      end,
      back = function(key)
	 if key == "backspace" or key == "escape" or key == "b" or
	 key == "a" or key == "j" or key == "left" then
	    return true
	 else
	    return false
	 end
      end
   }

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

   menu.highscores.update_bool = false
   menu.highscores.draw_bool = false
   menu.highscores.isIn = false
   menu.highscores.comingIn = false
   menu.highscores.goingOut = false
   menu.highscores.rect.x = menu.highscores.rect.x_out
   menu.highscores.rect.x_speed = 0

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
   if menu.curButtonSet then
      menu.curButtonSet:update(dt)
   end

   if menu.waitForMenu_bool then
      if menu.curButtonSet.isOut then
	 menu.waitForMenu_bool = false
	 menu.waitForMenu_func(unpack(menu.waitForMenu_args or {}))
      end
   end

   if menu.highscores.update_bool then
      if menu.highscores.comingIn then
	 print("COMING IN! ",dt)
	 local rect = menu.highscores.rect
	 if predictIncr(rect.x_speed, rect.x_accel) > rect.x_in - rect.x then
	    print("\taccel")
	    rect.x_speed = rect.x_speed - rect.x_accel*dt
	 else
	    print("\tdecel")
	    rect.x_speed = rect.x_speed + rect.x_accel*dt
	 end
	 rect.x = rect.x + rect.x_speed*dt
	 if rect.x <= rect.x_in then
	    rect.x_speed = 0
	    rect.x = rect.x_in
	    menu.highscores.isIn = true
	    menu.highscores.comingIn = false
	 end
      elseif menu.highscores.goingOut then
	 local rect = menu.highscores.rect
	 if rect.x < rect.x_out then
	    rect.x_speed = rect.x_speed + rect.x_accel*dt
	 end
	 rect.x = rect.x + rect.x_speed*dt
	 if rect.x >= rect.x_out then
	    rect.x_speed = 0
	    rect.x = rect.x_out
	    menu.highscores.isIn = false
	    menu.highscores.goingOut = false
	    menu.highscores.update_bool = false
	    menu.highscores.draw_bool = false
	    menu.curButtonSet = menu.buttonSets[1]
	    menu.curButtonSet:selectButton(2)
	    menu.curButtonSet:comeIn()
	 end
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

   if menu.waitForMenu_bool then
      if key == "backspace" or key == "escape" or key == "b" or
      key == "a" or key == "j" or key == "left" then
	 menu.waitForMenu_bool = false
	 menu.curButtonSet:comeIn()
      end

   elseif menu.highscores.isIn or menu.highscores.comingIn then
      if menu.keyCheck.up(key) then
	 
      elseif menu.keyCheck.down(key) then
	 
      elseif menu.keyCheck.back(key) then
	 menu.highscores.goOut()
      end

   elseif menu.highscores.goingOut then
      if menu.keyCheck.back(key) then
	 menu.highscores.comeIn()
      end

   else
      if menu.keyCheck.up(key) then
	 newBtn = menu.curButtonSet.curBtn - 1
	 if newBtn < 1 then
	    newBtn = #menu.curButtonSet.buttons
	 end
	 menu.curButtonSet:selectButton(newBtn)

      elseif menu.keyCheck.down(key) then
	 newBtn = menu.curButtonSet.curBtn + 1
	 if newBtn > #menu.curButtonSet.buttons then
	    newBtn = 1
	 end
	 menu.curButtonSet:selectButton(newBtn)

      elseif menu.keyCheck.enter(key) then
	 menu.curButtonSet:activate()

      elseif menu.keyCheck.back(key) then
	 menu.curButtonSet:goBack()
      end
   end
end

function menu.draw()
   for gNum, graph in ipairs(menu.graphs) do
      love.graphics.setColor(menu.graphColors[gNum])
      graph:draw(menu.graphThicknesses[gNum])
   end

   if menu.curButtonSet then
      menu.curButtonSet:draw()
   end

   if menu.highscores.draw_bool then
      local rect = menu.highscores.rect
      love.graphics.setColor(rect.color)
      love.graphics.rectangle(
	 "fill",
	 rect.x, rect.y,
	 rect.w, rect.h
      )
   end
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
   inOutAccel = 1500,
   delayIncr = 0.1,

   new = function()
      local obj = {
	 buttons = {},
	 curBtn = 0,
	 divs = {},
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
      local w = fonts.menu:getWidth(text)
      if #self.buttons > 1 then
	 table.insert(
	    self.divs,
	    { speed = 0 }
	 )
	 w = math.max(w, self.div_w)
      end
      -- Determine if resting position needs to be changed
      local bNum = #self.buttons
      if -w < self.resting_x then
	 self.resting_x = -w
	 if self.isOut then
	    for _, btn in ipairs(self.buttons) do
	       btn.x = self.resting_x
	    end
	    for _, div in ipairs(self.divs) do
	       div.x = self.resting_x
	    end
	 else
	    self.divs[bNum-1].x = self.div_x_goal
	    self.buttons[bNum].x = self.btn_x_goal
	 end
      else
	 if self.isOut or self.goingOut then
	    self.divs[bNum-1].x = self.resting_x
	    self.buttons[bNum].x = self.resting_x
	 else
	    self.divs[bNum].x = self.div_x_goal
	    self.buttons[bNum].x = self.btn_x_goal
	 end
      end
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

   _delayElems = function(self)
      for bNum, btn in ipairs(self.buttons) do
	 btn.dly = self.delayIncr * (bNum-1)*2
      end
      for dNum, div in ipairs(self.divs) do
	 div.dly = self.delayIncr * (dNum*2-1)
      end
   end,

   comeIn = function(self)
      if self.isIn then
	 return
      end
      self.isIn = false
      self.isOut = false
      self.goingOut = false
      self.comingIn = true
      self:_delayElems()
   end,

   goOut = function(self)
      if self.isOut then
	 return
      end
      self.isIn = false
      self.comingIn = false
      self.isOut = false
      self.goingOut = true
      self:_delayElems()
   end,

   -- Updates an element. Assumes menu is either coming in or going out.
   -- @param dt  Change in time
   -- @param elem  Element object/table
   -- @return  True if element is fully update. False if element is not.
   _updateElem = function(self, elem, dt, goal)
      if elem.dly > 0 then
	 elem.dly = elem.dly - dt
	 if elem.dly > 0 then
	    if elem.speed > 0 then
	       elem.speed = math.max(elem.speed - self.inOutAccel*dt, 0)
	    elseif elem.speed < 0 then
	       elem.speed = math.min(elem.speed + self.inOutAccel*dt, 0)
	    end
	    return false
	 else
	    elem.dly = 0
	 end
      end
      if elem.x ~= goal then
	 if self.comingIn then
	    if predictIncr(elem.speed, self.inOutAccel) < goal - elem.x then
	       elem.speed = elem.speed + self.inOutAccel*dt
	    else
	       elem.speed = elem.speed - self.inOutAccel*dt
	    end
	 elseif self.goingOut then
	    elem.speed = elem.speed - self.inOutAccel*dt
	 end
	 elem.x = elem.x + elem.speed*dt
	 if (self.comingIn and elem.x >= goal) or
	 (self.goingOut and elem.x <= goal) then
	    elem.x = goal
	    elem.speed = 0
	    return true
	 else
	    return false
	 end
      else
	 return true
      end
   end,

   update = function(self, dt)
      if self.comingIn or self.goingOut then
	 local isDone = true
	 local goal = self.comingIn and self.btn_x_goal or self.resting_x
	 for bNum, btn in ipairs(self.buttons) do
	    if not self:_updateElem(btn, dt, goal) then
	       isDone = false
	    end
	 end
	 local goal = self.comingIn and self.div_x_goal or self.resting_x
	 for dNum, div in ipairs(self.divs) do
	    if not self:_updateElem(div, dt, goal) then
	       isDone = false
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
	       self.divs[bNum].x, y,
	       self.div_w, self.div_h
	    )
	    y = y + self.div_h + self.spacer_h
	 end
      end
   end
}
buttonSet_mt.__index = buttonSet
