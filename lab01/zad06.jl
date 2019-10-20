# Author: Paweł Rubin

function f(x)
    sqrt(x^2 + 1) - 1    
end

function g(x) 
    x^2 / (sqrt(x^2 + 1) + 1)
end

function f_vs_g(n)
    for i = 1:n
        x = Float64(8.0) ^ (-i)
        _f = f(x)
        _g = g(x)
        if _f != _g
            println("$i & $_f & $_g \\\\ \\hline")
        end
    end
end

f_vs_g(200)
