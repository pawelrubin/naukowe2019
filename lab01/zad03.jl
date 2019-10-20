# Author: Paweł Rubin

function get_spread(a :: Float64, b :: Float64)
    a_exponent = SubString(bitstring(a), 2:12)
    prev_b_exponent = SubString(bitstring(prevfloat(b)), 2:12)

    if a_exponent != prev_b_exponent
        return nothing
    end

    exponent = parse(Int, a_exponent, base = 2)

    return 2.0 ^ (exponent - 1023) * (2.0 ^ (-52))
end

intervals = [(0.5, 1.0), (1.0, 2.0), (2.0, 4.0)]

foreach(interval -> println("\$[$(interval[1]), $(interval[2]))\$ & $(get_spread(interval...)) \\\\ \\hline"),intervals)
