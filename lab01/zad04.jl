function find_rocky_number(start)
    num = start(Float64)
    while nextfloat(num) * (one(Float64) / nextfloat(num)) == one(Float64)
        num = nextfloat(num)
    end
    nextfloat(num)
end

println(find_rocky_number(one))
println(find_rocky_number(zero))
