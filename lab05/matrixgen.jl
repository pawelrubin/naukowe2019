# Pawel Zielinski
module matrixgen

using SparseArrays
using LinearAlgebra

export blockmat

function matcond(n::Int64, c::Float64)
	# Function generates a random square matrix A of size n with
	# a given condition number c.
	# Inputs:
	#	n: size of matrix A, n>1
	#	c: condition of matrix A, c>= 1.0
	#
	# Usage: matcond(10, 100.0)
	#
	# Pawel Zielinski
	if n < 2
		error("size n should be > 1")
	end
	if c< 1.0
		error("condition number  c of a matrix  should be >= 1.0")
	end
	(U,S,V)=svd(rand(n,n))
	return U*diagm(0 =>[LinRange(1.0,c,n);])*V'
end


function blockmat(n::Int64, l::Int64, ck::Float64)
	# Function generates a random block sparse matrix A of size n with
	# a given condition number ck of inner block Ak.
	#
	# Inputs:
	#	n: size of block matrix A, n>3
	#   l: size of inner matrices Ak, n mod l =0 (n is  divisible by l), l>1
	#	ck: condition of inner matrix Ak, ck>= 1.0	
	#
	# Usage: blockmat(100, 4 ,10.0)
	#
							
	if n < 4
		error("size n should be > 3")
	end
	if l < 2
		error("size l should be > 1")
	end
	if n%l!=0 
		error("n is not divisible by l")
	end
				
	nb=div(n,l)
	Ak=Matrix{Float64}(undef, l, l)
	
	arraySize = nb * l * l + 3 * (nb - 1) * l

	cols = Array{Int64}(undef, arraySize)
	rows = Array{Int64}(undef, arraySize)
	vals = Array{Float64}(undef, arraySize)
	index = 1

	for k in 1 : nb
		Ak = matcond(l, ck) # square matrix size = l
		
		for i in 1 : l, j in 1 : l
			cols[index] = (k - 1) * l + i
			rows[index] = (k - 1) * l + j
			vals[index] = Ak[i, j]
			index += 1
		end

		if k < nb
			for i in 1 : l
				cols[index] = (k - 1) * l + i
				rows[index] = k * l + i
				vals[index] = 0.3 * rand()
				index += 1
			end
		end
		if k > 1
			for i in 1 : l
				cols[index] = (k - 1) * l + i
				rows[index] = (k - 1) * l - 1
				vals[index] = 0.3 * rand()
				index += 1

				cols[index] = (k - 1) * l + i
				rows[index] = (k - 1) * l
				vals[index] = 0.3 * rand()
				index += 1
			end
		end 
	end
	
	return sparse(cols, rows, vals)
end # blockmat
	
end # matrixgen
