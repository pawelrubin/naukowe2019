# Author: Paweł Rubin

x = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
y = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

x32 = map(x -> Float32(x), x)
y32 = map(y -> Float32(y), y)

x64 = map(x -> Float64(x), x)
y64 = map(y -> Float64(y), y)

function a(x::Vector, y::Vector)
    S = 0.0
    for i = 1:length(x)
        S += x[i] * y[i]
    end
    S
end

function b(x::Vector, y::Vector)
    S = 0
    for i = length(x):-1:1
        S += x[i] * y[i]
    end
    S
end

function c(x::Vector, y::Vector)
    products = map(x -> x[1] * x[2], zip(x, y))
    sumPositives = foldl(+, sort(filter(x -> x >= 0, products), rev=true))
    sumNegatives = foldl(+, sort(filter(x -> x < 0, products)))
    sumNegatives + sumPositives
end

function d(x::Vector, y::Vector)
    products = map(x -> x[1] * x[2], zip(x, y))
    sumPositives = foldl(+, sort(filter(x -> x >= 0, products)))
    sumNegatives = foldl(+, sort(filter(x -> x < 0, products), rev=true))
    sumNegatives + sumPositives
end

algorithms = [a, b, c, d]

foreach(alg -> println("& ", alg(x32, y32), " \\\\ \\hline"), algorithms)
foreach(alg -> println("& ", alg(x64, y64), " \\\\ \\hline"), algorithms)
