# Author: Paweł Rubin

using Polynomials

wilkinsonCoefficients(;modified::Bool=false) = [
    1,
    -210.0 - 2.0^(-23.0)*modified,
    20615.0,
    -1256850.0,
    53327946.0,
    -1672280820.0,
    40171771630.0,
    -756111184500.0,
    11310276995381.0,
    -135585182899530.0,
    1307535010540395.0,
    -10142299865511450.0,
    63030812099294896.0,
    -311333643161390640.0,
    1206647803780373360.0,
    -3599979517947607200.0,
    8037811822645051776.0,
    -12870931245150988800.0,
    13803759753640704000.0,
    -8752948036761600000.0,
    2432902008176640000.0
] :: Array{Float64}

wc = wilkinsonCoefficients()

# Poly() - Construct a polynomial from its coefficients, lowest order first.
wilkinsonPoly = Poly(reverse(wc))
# poly() - Construct a polynomial from its roots. 
wilkinsonpoly = poly(collect(Float64, 1:20))
# roots() - Return the roots (zeros) of p, with multiplicity. 
# The number of roots returned is equal to the order of p.
# By design, this is not type-stable, the returned roots may be real or complex.
wilkinsonRoots = reverse(roots(wilkinsonPoly))

for k in 1:20
    z_k = wilkinsonRoots[k]
    println(
        "$k & $z_k & $(abs(wilkinsonPoly(z_k))) & $(abs(wilkinsonpoly(z_k))) & $(abs(z_k - k)) \\\\ \\hline"
    )
end

wcm = wilkinsonCoefficients(modified=true)
wilkinsonPoly = Poly(reverse(wcm))
wilkinsonRoots = reverse(roots(wilkinsonPoly))

for k in 1:20
    println("$k & $(wilkinsonRoots[k]) \\\\ \\hline")
end
