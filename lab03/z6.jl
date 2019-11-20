# Author: Paweł Rubin

include("./methods.jl")
using .methods

f1(x) = exp(1 - x) - 1 # root = 1
f2(x) = x * exp(-x) # root = 0
pf1(x) = -exp(1 - x)
pf2(x) = -exp(-x) * (x - 1)
delta = 10^(-5)
epsilon = 10^(-5)
maxit = 64

bisection_params_f1 = [
    (f1, 0.0, 2.0, delta, epsilon), (f1, 0.5, 1.5, delta, epsilon), (f1, -21.0, 37.0, delta, epsilon),
    (f2, -0.5, 0.5, delta, epsilon), (f2, -3.14, 2.79, delta, epsilon), (f2, -21.0, 37.0, delta, epsilon)
]

newton_params_f1 = [
    (f1, pf1, 0.99, delta, epsilon, maxit), (f1, pf1, 0.5, delta, epsilon, maxit), (f1, pf1, -42.0, delta, epsilon, maxit),
    (f2, pf2, 0.1, delta, epsilon, maxit), (f2, pf2, 0.5, delta, epsilon, maxit), (f2, pf2, 11.0, delta, epsilon, maxit)
]

euler_params_f1 = [
    (f1, 0.9, 1.2, delta, epsilon, maxit), (f1, 0.0, 2.0, delta, epsilon, maxit), (f1, -21.0, 37.0, delta, epsilon, maxit),
    (f2, 0.1, 0.2, delta, epsilon, maxit), (f2, 0.0, 2.0, delta, epsilon, maxit), (f2, -21.0, 37.0, delta, epsilon, maxit)
]

println("bisection")
foreach(bis_params ->
    println(join((bis_params[1:3]..., methods.mbisekcji(bis_params...)...), " & "), " \\\\ \\hline"),
    bisection_params_f1
)

println("newton")
foreach(new_params ->
    println(join((new_params[1:3]..., methods.mstycznych(new_params...)...), " & "), " \\\\ \\hline"),
    newton_params_f1
)

println("euler")
foreach(eul_params ->
    println(join((eul_params[1:3]..., methods.msiecznych(eul_params...)...), " & "), " \\\\ \\hline"),
    euler_params_f1
)

println(
    "newton experiments:\n",
    "f1, x0 > 1 := 1.2 & ", join(methods.mstycznych(f1, pf1, 1.2, delta, epsilon, maxit), " & "), " \\\\ \\hline\n",
    "f2, x0 > 1 := 1.2 & ", join(methods.mstycznych(f2, pf2, 1.2, delta, epsilon, maxit), " & "), " \\\\ \\hline\n",
    "f2, x0 = 1.0 ->   & ", join(methods.mstycznych(f2, pf2, 1.0, delta, epsilon, maxit), " & "), " \\\\ \\hline\n"
)
