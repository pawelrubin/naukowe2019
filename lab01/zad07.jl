function derivative(f, x0, h)
    return (f(x0 + h) - f(x0)) / h
end

function test_derivative()
    f(x) = sin(x) + cos(3*x)
    df = 0.11694228168853805
    for i = 1:54
        h = 2.0^(-i)
        rd_df = derivative(f, one(Float64), h)
        err = abs(df - rd_df)
        println(
            "\$2^{-$i}\$ & ", one(Float64) + h, " & $rd_df & $err \\\\ \\hline"
        )
    end
end

test_derivative()