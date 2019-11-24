# Author: Paweł Rubin

include("./methods.jl")
using .methods
using Test

acc = 10^(-5)

@testset "bisection method tests" begin
    @test bisection(x -> sin(x) - (x/2)^2, 1.5, 2.0, acc, acc)[1] ≈ 1.93375 atol=acc
    @test bisection(x -> x^2 - 1, 0.0, 2.0, acc, acc)[1] ≈ 1.0 atol=acc
end

@testset "newton method tests" begin
    @test newton(x -> sin(x) - (x/2)^2, x -> cos(x) - (x/2), 1.5, acc, acc, 64)[1] ≈ 1.93375 atol=acc
    @test newton(x -> x^2 - 1, x -> 2*x, 1.5, acc, acc, 64)[1] ≈ 1.0 atol=acc
end

@testset "euler method tests" begin
    @test euler(x -> sin(x) - (x/2)^2, 1.5, 2.0, acc, acc, 64)[1] ≈ 1.93375 atol=acc
    @test euler(x -> x^2 - 1, 0.0, 2.0, acc, acc, 64)[1] ≈ 1.0 atol=acc
end
