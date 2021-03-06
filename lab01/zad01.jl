# Author: Paweł Rubin

# List of types
TYPES = [Float16, Float32, Float64]

# Calculates macheps for a given Type
function get_machine_epsilon(type::Type)
    epsilon = one(type)
    while one(type) + epsilon / 2 > one(type)
        epsilon /= 2
    end
    epsilon
end

foreach(type -> 
    println(
        type, " & ",
        get_machine_epsilon(type)," & ",
        eps(type), " \\\\ \\hline"
    ), 
    TYPES
)

# Calculates eta for a given Type
function get_eta(type::Type)
    eta = one(type)
    while eta / 2 > 0 
        eta /= 2
    end
    eta
end

foreach(type -> 
    println(
        type, " & ",
        get_eta(type), " & ",
        nextfloat(type(0.0)), " \\\\ \\hline"
    ), 
    TYPES
)

# Calculates MAX value for a given Type
function get_max(type::Type)
    max = prevfloat(one(type))
    while !isinf(max * 2)
        max *= 2
    end
    max
end

foreach(type -> 
    println(
        type, " & ",
        get_max(type), " & ",
        floatmax(type), " \\\\ \\hline"
    ), 
    TYPES
)
