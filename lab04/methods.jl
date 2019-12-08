# Author: Paweł Rubin

module Methods

export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx

using PyPlot

"""
This function computes difference quotients for given function and vector of arguments.

Parameters:
x - arguments vector
f - values vector

Return:
fx - computed difference quotients vector
"""
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    len = length(f)
    fx = Vector{Float64}(undef, len)

    for i in 1:len
        fx[i] = f[i]
    end

    for i = 2:len
        for j = len:-1:i
            fx[j] = (fx[j] - fx[j - 1]) / (x[j] - x[j - i + 1])
        end
    end

    return fx
end

"""
This function computes Newton polynomial for given t.

Parameters:
x - argumentes vector
fx - difference quotients vector
t - argument for polynomial

Return:
nt - value of polynomial in t
"""
function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    len = length(x)
    nt = fx[len]

    for i = len - 1:-1:1
        nt = fx[i] + (t-x[i]) * nt
    end

    return nt
end

"""
This function computes coefficients of Newton polynomial in natural form.

Parameters:
x - arguments vector
fx - difference quotients vector

Return:
a - coefficients vector
"""
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    len = length(x)
    a = Vector{Float64}(undef, len)
    a[len] = fx[len]

    for i = len - 1:-1:1
        a[i] = fx[i] - a[i + 1] * x[i]

        for j = i + 1:len - 1
            a[j] = a[j] - a[j + 1] * x[i]
        end
    end

    return a
end

"""
Draws Newton polynomial of degree n for a given function in a given interval.

Parameters:
f - function to interpolate
a - start of interval
b - end of interval
n - degree of Newton polynomial
"""
function rysujNnfx(f, a::Float64, b::Float64, n::Int)
    SPREAD = 20

    nodes_limit = n + 1    
    h = (b - a) / n
    kh = Float64(0.0)

    x = Vector{Float64}(undef, n + 1)
    y = Vector{Float64}(undef, n + 1)
    f_x = Vector{Float64}(undef, n + 1)   
    args = Vector{Float64}(undef, SPREAD * nodes_limit)
    f_plot = Vector{Float64}(undef, SPREAD * nodes_limit)
    w_plot = Vector{Float64}(undef, SPREAD * nodes_limit)

    for i = 1:nodes_limit
        x[i] = a + kh
        y[i] = f(x[i])
        kh += h
    end

    f_x = ilorazyRoznicowe(x, y)
    kh = Float64(0.0)
    nodes_limit *= SPREAD
    h = (b - a) / (nodes_limit - 1)

    for i = 1:nodes_limit
        args[i] = a + kh
        w_plot[i] = warNewton(x, f_x, args[i])
        f_plot[i] = f(args[i])
        kh += h
    end

    clf()
    plot(args, f_plot, label="f(x)", linewidth=1.0)
    plot(args, w_plot, label="w(x)", linewidth=1.0)
    grid(true)
    legend(loc=2, borderaxespad=0)
    title("Interpolation of $f; n = $n")
    savefig("plot_$(f)_$n.png")
end

end
