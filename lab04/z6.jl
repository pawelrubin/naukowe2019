# Author: Paweł Rubin

include("./methods.jl")
using .Methods

a6(x) = abs(x)
b6(x) = 1 / (1 + x^2)

rysujNnfx(a6, -1.0, 1.0, 5)
rysujNnfx(a6, -1.0, 1.0, 10)
rysujNnfx(a6, -1.0, 1.0, 15)

rysujNnfx(b6, -5.0, 5.0, 5)
rysujNnfx(b6, -5.0, 5.0, 10)
rysujNnfx(b6, -5.0, 5.0, 15)
