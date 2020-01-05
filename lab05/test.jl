include("./blocksys.jl")
using .blocksys

function testData()
    testDataSet = [16, 10000, 50000]

    for test in testDataSet
        matrixFile = open("data/_$(test)/A.txt")
        vectorFile = open("data/_$(test)/b.txt")

        (M, n, l) = readMatrixFromFile(matrixFile)
        b = readVectorFromFile(vectorFile)
        gaussSolution = solveWithGauss(M, b, n, l)
        pivotedGaussSolution = solveWithPivotedGauss(M, b, n, l)

        println(gaussSolution)
        println(pivotedGaussSolution)
    end
end

testData()