states = {}

function load_state(state)
   love.update = states[state].update
   love.draw = states[state].draw
   love.keypressed = states[state].keypressed
   love.keyreleased = states[state].keyreleased
end
