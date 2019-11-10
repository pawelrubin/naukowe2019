# Author: Paweł Rubin

using DelimitedFiles

function x(n::Int, c::Float64, x0::Float64)
    result = zeros(Float64, 0)

    x = x0

    for i in 1:n
        x = x^2 + c
        append!(result, x)
    end

    return result
end

params = [(-2.0, 1.0), (-2.0, 2.0), (-2.0, 1.99999999999999), (-1.0, 1.0), (-1.0, -1.0), (-1.0, 0.75), (-1.0, 0.25)]

for (i, param) in enumerate(params)
    writedlm("result$i.csv", x(40, param...), ',')
end
