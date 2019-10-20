# Author: Paweł Rubin

TYPES = [Float16, Float32, Float64]

function kahan_eps(type)
    type(3) * (type(4) / type(3) - one(type)) - one(type)
end

foreach(type -> 
    println(
        kahan_eps(type),
        " vs ",
        eps(type)
    ),
    TYPES
)
