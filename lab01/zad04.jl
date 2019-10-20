function find_frantic_number(start)
    num = start(Float64)
    while nextfloat(num) * (one(Float64) / nextfloat(num)) == one(Float64)
        num = nextfloat(num)
    end
    nextfloat(num)
end

println(find_frantic_number(one))
println(find_frantic_number(zero))
