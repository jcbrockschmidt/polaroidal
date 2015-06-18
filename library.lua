function modulus(a, b)
   return a - math.floor(a / b) * b
end

function isEven(a)
   return modulus(math.abs(a) + 0.5, 2) < 1
end

function isOdd(a)
   return not isEven(a)
end

-- Determines how some value will increase if it is increasing at a given rate
-- and decelerating at a given rate.
-- @param speed  Current increase-per-second rate.
-- @param decel  Deceleration-per-second rate.
function predictIncr(speed, decel)
   return (speed*speed) / decel
end
