# Author: Paweł Rubin

include("./methods.jl")
using .methods

f(x) = 3 * x
g(x) = exp(x)
delta = 10^(-4)
epsilon = 10^(-4)
f_g(x) = f(x) - g(x)

a, b = 0.5, 1.0
println(join(bisection(f_g, a, b, delta, epsilon), " & "), " \\\\ \\hline")

a, b = 1.0, 2.0
println(join(bisection(f_g, a, b, delta, epsilon), " & "), " \\\\ \\hline")
