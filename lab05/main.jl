include("./io_handler.jl")
include("./matrixgen.jl")
include("./blocksys.jl")
include("./utils.jl")
using .IOHandler
using .matrixgen
using .blocksys
using .Utils

using Dates
using Base.Filesystem

solvers = [solveWithGauss, solveWithPivotedGauss, solveWithGaussLU, solveWithPivotedGaussLU]

function benchmark(solvers)
    INTERVAL = 400
    BLOCK_SIZE = 4
    MAX = 15000
    REPS = 1
    timestamp = Dates.now()
    mkdir("results/$timestamp")
    foreach(solver -> (
        solverName = getFunctionName(solver);
        open("results/$timestamp/$solverName.csv", "w") do file
            write(file, "size; time; memory\n")
            for size in INTERVAL:INTERVAL:MAX
                time = 0
                memory = 0
                for rep in 1:REPS
                    filename = "/tmp/$(size)_$(rep)_$solverName"
                    blockmat(size, BLOCK_SIZE, 1.0, filename)
                    open(filename) do file
                        M, n, l = readMatrixFromFile(file)
                        b = calculateRightSide(M, n, l)
                        (_, t, m) = @timed solver(M, b, n, l)
                        time += t
                        memory += m
                    end
                end

                write(file, "$size; $(time / REPS); $(memory / REPS)\n")
            end

        end
    ), solvers)
end


benchmark(solvers)