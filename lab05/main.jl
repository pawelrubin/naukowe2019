include("./benchmark.jl")
using .benchmark

println(@time solversBenchmark(Int64(400), Int64(15000), Int64(4), Int64(10)))
