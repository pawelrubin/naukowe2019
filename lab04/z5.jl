# Author: Paweł Rubin

include("./methods.jl")
using .Methods

a5(x) = exp(x)
b5(x) = (x^2)*sin(x)

rysujNnfx(a5, 0.0, 1.0, 5)
rysujNnfx(a5, 0.0, 1.0, 10)
rysujNnfx(a5, 0.0, 1.0, 15)

rysujNnfx(b5, -1.0, 1.0, 5)
rysujNnfx(b5, -1.0, 1.0, 10)
rysujNnfx(b5, -1.0, 1.0, 15)
