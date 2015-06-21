function love.conf (c)
   c.identity = "polaroidal"
   c.version = "0.9.2"
   c.console = false
   
   c.window.width = 800
   c.window.height = 600
   c.window.title = "Polaroidal"
   c.window.icon = nil
   c.window.borderless = false
   c.window.resizeable = true
   c.window.minwidth = 800
   c.window.minheight = 600
   c.window.fullscreen = false
   c.window.fullscreentype = "normal"
   c.window.vsync = true
   
   c.modules.audio = true
   c.modules.event = true
   c.modules.graphics = true
   c.modules.image = true
   c.modules.joystick = true
   c.modules.keyboard = true
   c.modules.math = true
   c.modules.mouse = true
   c.modules.physics = false
   c.modules.sound = true
   c.modules.system = true
   c.modules.timer = true
   c.modules.window = true
   c.modules.thread = true
end
