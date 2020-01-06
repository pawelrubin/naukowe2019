module blocksys
export solveWithGauss, solveWithPivotedGauss, solveWithGaussLU, solveWithPivotedGaussLU
export calculateRightSide
export solvers

using SparseArrays

function calculateRightSide(M::SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64)
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
        for i in k + 1 : min(n, k + l + 1)
            z = M![i, k] / M![k, k]
            M![i, k] = 0.0

            for col in k + 1 : min(n, k + l + 1)
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

    # columns
    for k in 1 : n - 1
        maxInColValue = 0
        maxInColIndex = 0

        # rows
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
Generates LU decomposition with Gauss elimination.

Input
    M! - sparce matrix
    n - matrix size
    l - block size

Output
    L - lower triangular matrix
"""
function gaussLU!(M!::SparseMatrixCSC{Float64, Int64}, n::Int64, l::Int64)
    L = spzeros(n, n)

    for k in 1 : n - 1
        L[k, k] = 1.0
        for i in k + 1 : min(n, k + l + 1)
            z = M![i, k] / M![k, k]
            L[i, k] = z 
            M![i, k] = 0.0
            for j in k + 1 : min(n, k + l)
                M![i, j] -=  z * M![k, j]
            end
        end
    end
    
    L[n, n] = 1
    
    return L
end

"""
Generates LU decomposition with pivoted Gauss elimination.

Input
    M! - sparce matrix
    n - matrix size
    l - block size

Output
    L - lower triangular matrix
    perm - permutations array
"""
function gaussPivotedLU!(M!::SparseMatrixCSC{Float64, Int64}, n::Int64, l::Int64)
    L = spzeros(n, n)

    perm = collect(1 : n)

    # columns
    for k in 1 : n - 1
        maxInColValue = 0
        maxInColIndex = 0

        # rows
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

            L[perm[i], k] = z
            M![perm[i], k] = 0.0

            for j in k + 1 : min(n, k + 2 * l)
                M![perm[i], j] -= z * M![perm[k], j]
            end
        end
    end

    return L, perm
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
Solves Ax=b with Pivoted Gauss elimination

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


"""
Solves Ax=b with Gauss elimination and LU decomposition.

Input:
    M - sparce matrix
    b - right side Vector
    n - matrix size
    l - block size

Output
    x_n - result Vector
"""
function solveWithGaussLU(M::SparseMatrixCSC{Float64, Int64}, b::Vector{Float64}, n::Int64, l::Int64)
    L = gaussLU!(M, n, l)
        
    x_n = zeros(Float64, n)

    # Lz = b
    for k in 1 : n - 1
        for i in k + 1 : min(n, k + l + 1)
            b[i] -= L[i, k] * b[k]
        end
    end
    
    # Ux = z
    for i in n : -1 : 1
        x_i = 0
        for j in i + 1 : min(n, i + l)
            x_i += M[i, j] * x_n[j]
        end
        x_n[i] = (b[i] - x_i) / M[i, i]
    end

    return x_n
end


"""
Solves Ax=b with Pivoted Gauss elimination and LU decomposition.

Input:
    M - sparce matrix
    b - right side Vector
    n - matrix size
    l - block size

Output
    x_n - result Vector
"""
function solveWithPivotedGaussLU(M::SparseMatrixCSC{Float64, Int64}, b::Vector{Float64}, n::Int64, l::Int64)
    L, perm = gaussPivotedLU!(M, n, l)
    
    x_n = zeros(Float64, n)

    # Lz = Pb
    for k in 1 : n - 1
        for i in k + 1 : min(n, k + l + 1)
            b[perm[i]] -= L[perm[i], k] * b[perm[k]]
        end
    end
    
    # Ux = z
    for i in n : -1 : 1
        x_i = 0
        for j in i + 1 : min(n, i + 2 * l)
            x_i += M[perm[i], j] * x_n[j]
        end
        x_n[i] = (b[perm[i]] - x_i) / M[perm[i], i]
    end

    return x_n
end

solvers = [solveWithGauss, solveWithPivotedGauss, solveWithGaussLU, solveWithPivotedGaussLU]

end
