# Restrict arrays to numbers
typealias NumVector{T<:Number} Vector{T}
typealias NumMatrix{T<:Number} Matrix{T}
typealias NumArray{T<:Number,N} Array{T,N}

# Indices are a vector of integers or a single integer
typealias Indices{T<:Integer} Union{Integer, Vector{T}}

# SquareMatrix: number of rows equal the number of columns
type SquareMatrix{T<:Number} <: AbstractMatrix{T}
    M::Matrix{T}

    function SquareMatrix(A::Matrix)
        if size(A,1) != size(A,2)
            error("Matrix must be square.")
        end
        return new(A)
    end
end

# SquareMatrix constructor uses matrix reference rather than copying
SquareMatrix{T<:Number}(A::Matrix{T}) = SquareMatrix{T}(A)

# convert from SquareMatrix to Matrix
convert{T}(::Type{Matrix{T}}, A::SquareMatrix{T}) = A.M
promote_rule{T}(::Type{Matrix{T}}, ::Type{SquareMatrix{T}}) = Matrix{T}
promote_rule{T,S}(::Type{Matrix{T}}, ::Type{SquareMatrix{S}}) = Matrix{promote_type(T,S)}

# define SquareMatrix operations
full(A::SquareMatrix) = A.M
print_matrix(io::IO, A::SquareMatrix) = print_matrix(io, full(A))
transpose(A::SquareMatrix) = SquareMatrix(transpose(A.M))
ctranspose(A::SquareMatrix) = SquareMatrix(ctranspose(A.M))

for op in (:size, :getindex, :setindex!)
    @eval begin
        ($op)(A::SquareMatrix, args::Real...) = ($op)(A.M, args...)
    end
end

for op in (:+, :-, :*, :/, :.*, :./)
    @eval begin
        ($op)(A::SquareMatrix, n::Number) = ($op)(A.M, n)
        ($op)(n::Number, A::SquareMatrix) = ($op)(A, n)
        ($op)(A::SquareMatrix, B::Matrix) = ($op)(promote(A,B)...)
        ($op)(B::Matrix, A::SquareMatrix) = ($op)(A, B)
        ($op)(A::SquareMatrix, B::SquareMatrix) = SquareMatrix(($op)(A.M, B.M))
    end
end
