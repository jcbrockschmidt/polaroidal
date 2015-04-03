states = {}

function load_state(state)
   cur_state = state
   states[state].reload()
   love.update = states[state].update
   love.draw = states[state].draw
   love.keypressed = states[state].keypressed
   love.keyreleased = states[state].keyreleased
end
