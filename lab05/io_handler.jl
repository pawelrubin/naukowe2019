module IOHandler
export readMatrixFromFile, readVectorFromFile

using SparseArrays


"""
Reads matrix from file.
"""
function readMatrixFromFile(file::IOStream)
    sn, sl = split(readline(file))

    n = parse(Int64, sn)
    l = parse(Int64, sl)

    rows    = Int64[]
    columns = Int64[]
    values  = Float64[]

    for line in eachline(file)
        row, column, value = split(line)
        push!(rows,     parse(Int64, row)       )
        push!(columns,  parse(Int64, column)    )
        push!(values,   parse(Float64, value)   )
    end

    M = sparse(rows, columns, values)
    return (M, n, l)
end


"""
Reads vector from file.
"""
function readVectorFromFile(file::IOStream)
    words = split(readline(file))
    n = parse(Int, words[1])

    b = Array{Float64}(undef, n)

    for (i, line) in enumerate(eachline(file))
        b[i] = parse(Float64, line)
    end

    return b    
end

end