TYPES = [Float16, Float32, Float64]

function get_machine_epsilon(type)
    epsilon = one(type)
    while one(type) + epsilon / 2 > one(type)
        epsilon /= 2
    end
    epsilon
end

foreach(type -> 
    println(
        "Iter eps: ", get_machine_epsilon(type),
        " eps($type): ", eps(type)
    ), 
    TYPES
)

function get_eta(type)
    eta = one(type)
    while eta / 2 > 0 
        eta /= 2
    end
    eta
end

foreach(type -> 
    println(
        "Iter eta: ", get_eta(type),
        " nextfloat($type(0.0)): ", nextfloat(type(0.0))
    ), 
    TYPES
)

function get_max(type)
    max = one(type)
    while !isinf(max * 2)
        max *= 2
    end
    max
end

foreach(type -> 
    println(
        "Iter MAX: ", get_max(type),
        " floatmax($type): ", floatmax(type)
    ), 
    TYPES
)