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

using Base.Filesystem
using Dates
using Test

function solversBenchmark(interval::Int64, max_size::Int64, block_size::Int64, repetitions::Int64)
    dir_name = "results/$(join([interval, max_size, block_size, repetitions], "_")).csv"
    mkpath(dir_name)

    timeResultFile = open("$dir_name/time.csv", "w")
    memoryResultFile = open("$dir_name/memory.csv", "w")
    labels = "n;"
    foreach(solver -> labels *= "$(getFunctionName(solver));", solvers)
    write(timeResultFile, "$labels\n")
    write(memoryResultFile, "$labels\n")

    for n in interval:interval:max_size
        memoryResult = "$n;"
        timeResult = "$n;"

        foreach(solver -> (
            solverName = getFunctionName(solver);
            time = 0;
            memory = 0;
            for rep in 1:repetitions
                M = blockmat(n, block_size, 1.0)
                b = calculateRightSide(M, n, block_size)
                x, t, m = @timed solver(M, b, n, block_size)
                @test isapprox(x, ones(Float64, n))
                time += t
                memory += m
            end;
            memoryResult *= "$(memory / repetitions);";
            timeResult *= "$(time / repetitions);";
        ), solvers)

        write(timeResultFile, "$timeResult\n")
        write(memoryResultFile, "$memoryResult\n")    
    end
end

end
