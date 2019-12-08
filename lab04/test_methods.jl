# Author: Paweł Rubin

include("./methods.jl")
using .Methods
using Test

x1 = [3.0, 1.0, 5.0, 6.0]
f1 = [1.0, -3.0, 2.0, 4.0]
w1 = [1.0, 2.0, -3.0/8.0, 7.0/40.0]

x2 = [-1.0, 0.0, 1.0, 2.0, 3.0]
f2 = [2.0, 1.0, 2.0, -7.0, 10.0]
w2 = [2.0, -1.0, 1.0, -2.0, 2.0]

@testset "ilorazyRoznicowe" begin
    @test isapprox(ilorazyRoznicowe(x1, f1), w1)
    @test isapprox(ilorazyRoznicowe(x2, f2), w2)
end

w3 = ilorazyRoznicowe(x2, f2)

@testset "warNewton" begin
    @test isapprox(warNewton(x2, w3, 2.0), -7.0)
    @test isapprox(warNewton(x2, w3, 10.0), 13961.0)
    @test isapprox(warNewton(x2, w3, 5.0), 506.0)
    @test isapprox(warNewton(x2, w3, -3.0), 298.0)
end

w4 = [3.0, 30.0, -8.0, -27.0, 10.0]
@testset "naturalna" begin
    @test isapprox(naturalna(x2, f2), w4)
end
