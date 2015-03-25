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
      end )
   menu.buttonSets[1]:addButton("Options", function() return end)
   menu.buttonSets[1]:addButton("Credits", function() return end)
   menu.buttonSets[1]:addButton("Exit", function() return end)
   menu.buttonSets[2]:addButton("Challenge", function() return end)
   menu.buttonSets[2]:addButton("Casual", function() return end)
   menu.buttonSets[2]:addButton("Timed", function() return end)
   menu.curButtonSet = menu.buttonSets[1]
end

function menu.draw()
   menu.curButtonSet:draw()
end

local buttonSet_mt = {}
buttonSet = {
   dx = 20,
   dy = 20,
   btn_h = 0, --> Will be set in menu.load()
   div_h = 4,
   div_w = 150,
   spacer_w = 8,
   spacer_h = 6,
   selectColor = {0, 0, 255, 255},
   regularColor = {100, 100, 255, 255},
   divColor = {0, 0, 100, 255},

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

   draw = function(self)
      love.graphics.setFont(fonts.menu)
      local x = self.dx + self.spacer_w
      local y = self.dy
      for bNum, btn in ipairs(self.buttons) do
	 if bNum == self.curBtn then
	    love.graphics.setColor(self.selectColor)
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
