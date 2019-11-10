# Author: Paweł Rubin
include("hilb.jl")
include("matcond.jl")
    
function testMatrix(A, n)
    x = ones(Float64, n)
    b = A * x

    gauss_err = norm(A \ b - x)/norm(x)
    inv_err = norm(inv(A) * b - x)/norm(x)

    println("$n & $(rank(A)) & $(cond(A)) & $(gauss_err) & $(inv_err) \\\\ \\hline")
end

for n in 1:2:30
    testMatrix(hilb(n), n)
end

for n in [5, 10, 20]
    for c in [1.0, 10.0, 10.0^3, 10.0^7, 10.0^12, 10.0^16]
        testMatrix(matcond(n, c), n)
    end
end
