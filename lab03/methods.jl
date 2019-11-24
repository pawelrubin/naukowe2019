# Author: Paweł Rubin

module methods

export bisection, newton, euler

"""
Solves the formula f(x) = 0 using the bisection method.

Input:
f               – anonymous function
a,b             – interval
delta, epsilon  – calculations accuracy

Output: (r,v,it,err)
r   – root of f
v   – f(r)
it  – number of iterations
err – error code
    0 – no error
    1 – f does not change sign in [a,b]
"""
function bisection(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    u = f(a)
    v = f(b)
    e = b - a

    it = 0

    if sign(u) == sign(v)
        return (NaN, NaN, NaN, 1)
    end
    
    while e > epsilon
        it += 1
        e /= 2
        c = a + e
        w = f(c)

        if abs(e) < delta || abs(w) < epsilon
            return (c, w, it, 0)
        end

        if sign(w) != sign(u) 
            b = c
            v = w
        else
            a = c
            u = w
        end
    end
end

"""
Solves the formula f(x) = 0 using the Newton method.

Input:
f, pf           – anonymous function f and derivative of f
x0              – initial approximation 
delta, epsilon  – calculations accuracy
maxit           – maximum number of iterations

Output: (r,v,it,err)
r   – root of f
v   – f(r)
it  – number of iterations
err – error code
    0 – no error
    1 – did not achieve required accuracy
    2 – derivative close to zero
"""
function newton(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)

    if abs(v) < epsilon
        return (x0, v, 0, 0)
    end

    if abs(pf(x0)) < epsilon
        return (NaN, NaN, NaN, 2)
    end

    for it = 1:maxit
        x1 = x0 - v / pf(x0)
        v = f(x1)

        if abs(x1 - x0) < delta || abs(v) < epsilon
            return (x1, v, it, 0)
        end
        
        x0 = x1
    end
    
    return (NaN, NaN, NaN, 1)
end

"""
Solves the formula f(x) = 0 using the Euler method.

Input:
f               – anonymous function f
x0, x1          – initial approximations 
delta, epsilon  – calculations accuracy
maxit           – maximum number of iterations

Output: (r,v,it,err)
r   – root of f
v   – f(r)
it  – number of iterations
err – error code
    0 – no error
    1 – did not achieve required accuracy
"""
function euler(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    fx0 = f(x0)
    fx1 = f(x1)

    for it = 1:maxit
        if abs(fx0) > abs(fx1)
            x0, x1, = x1, x0
            fx0, fx1 = fx1, fx0
        end

        s = (x1 - x0)/(fx1 - fx0)
        x1 = x0
        fx1 = fx0
        x0 = x0 - (fx0 * s)
        fx0 = f(x0)

        if abs(x1 - x0) < delta || abs(fx0) < epsilon
            return (x0, fx0, it, 0)
        end
    end

    return (NaN, NaN, NaN, 1)
end

end
