# Author: Paweł Rubin

function p(n::Int, r, p0)
    if n == 0
        return p0
    end
    p_next = p(n-1, r, p0)
    return p_next + r * p_next * (1 - p_next)
end

function toFixed(n, k)
    return trunc(n*10^k)/10^k
end

function test1()
    
p_trunc = p(10, Float32(3), Float32(0.01))
p_trunc = p(10, Float32(3), Float32(toFixed(p_trunc, 3)))
p_trunc = p(10, Float32(3), Float32(toFixed(p_trunc, 3)))
p_trunc = p(10, Float32(3), Float32(toFixed(p_trunc, 3)))
println("40 iterations, truncated every 10 iterations: ", p_trunc)
end

function test2()
    for type in [Float32, Float64]
        println("40 iterations $type: ", p(40, type(3), type(0.01)))
    end
end

test1()
test2()