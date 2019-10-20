# Author: Paweł Rubin

# Calculates smallest x such that x * (1/x) != 1 starting from a given number
function find_frantic_number(start)
    num = start(Float64)
    while nextfloat(num) * (one(Float64) / nextfloat(num)) == one(Float64)
        num = nextfloat(num)
    end
    nextfloat(num)
end

println(find_frantic_number(one))
println(find_frantic_number(zero))
