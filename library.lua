function modulus(a, b)
   return a - math.floor(a / b) * b
end

function isEven(a)
   return modulus(math.abs(a) + 0.5, 2) < 1
end

function isOdd(a)
   return not isEven(a)
end
