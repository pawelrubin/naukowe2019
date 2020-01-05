module blocksys
export gauss!, gaussPivoted!, solveWithGauss, solveWithPivotedGauss, solveWithGaussLU

using SparseArrays


function calculateRightSide(M::SparseMatrixCSC{Float64,Int}, n::Int, l::Int)
    b = zeros(Float64, n)

    for i in 1 : n
        for j in max(1, i - (2 + l)) : min(n, i + l)
            b[i] += M[i, j]
        end
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
Input
    M! - sparce matrix
    n - matrix size
    l - block size

Output
    L, U - lower triangular and upper triangular matrices 
"""
function gaussLU(M::SparseMatrixCSC{Float64, Int64}, n::Int64, l::Int64)
    U = copy(M)
    L = spzeros(n, n)

    for k in 1 : n - 1
        L[k, k] = 1.0
        for i in k + 1 : min(n, k + l + 1)
            z = U[i, k] / U[k, k]
            L[i, k] = z 
            U[i, k] = 0.0
            for j in k + 1 : min(n, k + l)
                U[i, j] -=  z * U[k, j]
            end
        end
    end
    L[n, n] = 1
    return L, U
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


function solveWithGaussLU(M::SparseMatrixCSC{Float64, Int64}, b::Vector{Float64}, n::Int64, l::Int64)
    L, U = gaussLU(M, n, l)
        
    x_n = zeros(Float64, n)

    # Lz = b
    for k in 1 : n - 1
        for i in k + 1 : min(n, k + l + 1)
            b[i] -= L[i, k] * b[k]
        end
    end
    
    # Ux = z
    for i in n : -1 : 1
        sum = 0
        for j in i + 1 : min(n, i + l)
            sum += U[i, j] * x_n[j]
        end
        x_n[i] = (b[i] - sum) / U[i, i]
    end

    return x_n
end

end
