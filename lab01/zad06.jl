function f(x)
    sqrt(x^2 + one(Float64)) - one(Float64)    
end

function g(x)
    x^2 / (sqrt(x^2 + one(Float64)) + one(Float64))
end

function f_vs_g(n)
    for i = one(Float64):n
        x = Float64(8.0) ^ (-i)
        _f = f(x)
        _g = g(x)
        if _f != _g
            println("i = $i, x = $x; f(x): $_f vs $_g :(x)g")
        end
    end
end

f_vs_g(100)