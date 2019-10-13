function derivative(f, x0, h, type)
    return (f(type(x0) + type(h)) - f(type(x0))) / type(h)
end

function test_derivative(type)
    f(x) = sin(x) + cos(3*x)
    df = 0.11694228168853805
    for i = 1:54
        rd_df = derivative(f, one(type), type(2.0^(-i)), type)
        err = abs(df - rd_df)
        println(
            "h = 2^$i ",
            "rd(f'(x)) = $rd_df vs $df | err = $err"
        )
    end
end

test_derivative(Float64)