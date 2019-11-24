# Author: Paweł Rubin

include("./methods.jl")
using .methods

f(x) = sin(x) - (x/2)^2
pf(x) = cos(x) - (x/2)
delta = 10^(-5) / 2
epsilon = 10^(-5) / 2
maxit = 20

results = [
    bisection(f, 1.5, 2.0, delta, epsilon),
    newton(f, pf, 1.5, delta, epsilon, maxit),
    euler(f, 1.0, 2.0, delta, epsilon, maxit)
]

foreach(result -> println(join(result, " & "), " \\\\ \\hline"), results)
