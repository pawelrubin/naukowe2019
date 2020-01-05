include("../blocksys.jl")
include("../io_handler.jl")
include("../utils.jl")
using .blocksys
using .IOHandler
using .Utils

using Test

function testSolvers(solvers)
    testDataIndexes = [16, 10000, 50000]
    testData = []

    # read test data
    for index in testDataIndexes
        matrixFile = open("./data/_$(index)/A.txt")
        vectorFile = open("./data/_$(index)/b.txt")
        (M, n, l) = readMatrixFromFile(matrixFile)
        b = readVectorFromFile(vectorFile)
        push!(testData, (M, b, n, l))
    end

    foreach(solver -> 
        @testset "$(getFunctionName(solver))" begin
            foreach(test -> 
                @test isapprox(solver(test...), ones(Float64, test[3]))
            , testData)
        end
    , solvers)
end

solvers = [solveWithGauss, solveWithPivotedGauss, solveWithGaussLU, solveWithPivotedGaussLU]

testSolvers(solvers)