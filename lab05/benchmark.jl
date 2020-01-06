module benchmark
export solversBenchmark

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

function solversBenchmark()
    INTERVAL::Int64 = 400
    BLOCK_SIZE::Int64 = 4
    MAX::Int64 = 15000
    REPS::Int64 = 1

    timestamp = Dates.now()
    mkdir("results/$timestamp")
    foreach(solver -> (
        solverName = getFunctionName(solver);
        open("results/$timestamp/$solverName.csv", "w") do file
            write(file, "n; time; memory\n")
            for n in INTERVAL:INTERVAL:MAX
                time = 0
                memory = 0
                for rep in 1:REPS
                    M = blockmat(n, BLOCK_SIZE, 1.0)
                    b = calculateRightSide(M, n, BLOCK_SIZE)
                    (_, t, m) = @timed solver(M, b, n, BLOCK_SIZE)
                    time += t
                    memory += m
                end

                write(file, "$n; $(time / REPS); $(memory / REPS)\n")
            end

        end
    ), solvers)
end

end
