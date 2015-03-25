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
	 love.event.quit()
      end )
   menu.buttonSets[2]:addButton("Challenge", function() return end)
   menu.buttonSets[2]:addButton("Casual", function() return end)
   menu.buttonSets[2]:addButton("Timed", function() return end)
   menu.buttonSets[2]:setBack(
      function ()
	 menu.curButtonSet = menu.buttonSets[1]
	 menu.curButtonSet:selectButton(1)
      end )

   menu.curButtonSet = menu.buttonSets[1]
   menu.curButtonSet:selectButton(1)
end

function menu.keypressed(key)
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

   elseif key == " " or key == "return" then
      menu.curButtonSet:activate()

   elseif key == "backspace" or key == "b" then
      menu.curButtonSet:goBack()
   end
end

function menu.draw()
   menu.curButtonSet:draw()
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
   end,

   setBack = function(self, func)
      self.backFunc = func
   end,

   goBack = function(self)
      if self.backFunc then
	 self.backFunc()
      end
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
