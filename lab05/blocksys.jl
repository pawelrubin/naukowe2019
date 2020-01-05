module blocksys
export readMatrixFromFile, readVectorFromFile, gauss!, gaussPivoted!, solveWithGauss, solveWithPivotedGauss

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


"""
In-place Gauss elimination

Input
    M! - sparce matrix
    b! - right side Vector
    n - matrix size
    l - block size
"""
function gauss!(M!::SparseMatrixCSC{Float64, Int64}, b!::Vector{Float64}, n::Int64, l::Int64)
    for k in 1 : n -1
        last_row = min(n, k + l + 1)
        last_col = min(n, k + l + 1)
        # last_col = min(n, k + l + k % l + 2)

        for i in k + 1 : last_row
            z = M![i, k] / M![k, k]
            M![i, k] = 0.0

            for col in k + 1 : last_col
                M![i, col] -= z * M![k, col]
            end
            
            b![i] -= z* b![k]
        end
    end
end


"""
In-place pivoted Gauss elimination

Input
    M! - sparce matrix
    b! - right side Vector
    n - matrix size
    l - block size
"""
function gaussPivoted!(M!::SparseMatrixCSC{Float64, Int64}, b!::Vector{Float64}, n::Int64, l::Int64)
    perm = collect(1 : n)

    # i_n
    for k in 1 : n - 1
        maxInColValue = 0
        maxInColIndex = 0

        # j_n
        for i in k : min(n, k + l + 1)
            if abs(M![perm[i], k]) > maxInColValue
                maxInColValue = abs(M![perm[i], k])
                maxInColIndex = i
            end
        end

        # swap 
        perm[maxInColIndex], perm[k] = perm[k], perm[maxInColIndex]

        for i in k + 1 : min(n, k + l + 1)
            z = M![perm[i], k] / M![perm[k], k]
            M![perm[i], k] = 0.0

            for j in k + 1 : min(n, k + 2 * l)
                M![perm[i], j] -= z * M![perm[k], j]
            end
            b![perm[i]] -= z * b![perm[k]]
        end
    end

    return perm
end


"""
Solves Ax=b with Gauss elimination

Input:
    M - sparce matrix
    b - right side Vector
    n - matrix size
    l - block size

Output
    x_n - result Vector
"""
function solveWithGauss(M::SparseMatrixCSC{Float64, Int64}, b::Vector{Float64}, n::Int64, l::Int64)
    gauss!(M, b, n, l)
    
    x_n = zeros(Float64, n)

    for i in n:-1:1
        x_i = 0
        for j in i + 1 : min(n, i + l)
            x_i += M[i, j] * x_n[j]
        end
        x_n[i] = (b[i] - x_i) / M[i, i]
    end

    return x_n
end


"""
Solves Ax=b with Gauss elimination

Input:
    M - sparce matrix
    b - right side Vector
    n - matrix size
    l - block size

Output
    x_n - result Vector
"""
function solveWithPivotedGauss(M::SparseMatrixCSC{Float64, Int64}, b::Vector{Float64}, n::Int64, l::Int64)
    perm = gaussPivoted!(M, b, n, l)

    x_n = zeros(Float64, n)

    # Lz = Pb
    for k in 1 : n-1
        for i in k + 1 : min(n, k + 2 * l)
            b[perm[i]] -= M[perm[i], k] * b[perm[k]]
        end
    end

    # Ux = z
    for i in n:-1:1
        x_i = 0
        for j in i + 1 : min(n, i + 2 * l)
            x_i += M[perm[i], j] * x_n[j]
        end
        x_n[i] = (b[perm[i]] - x_i) / M[perm[i], i]
    end

    return x_n
end

end
