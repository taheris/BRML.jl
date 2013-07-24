module Types


typealias NumVector{T<:Number} AbstractVector{T}
typealias NumMatrix{T<:Number} AbstractMatrix{T}
typealias NumArray{T<:Number,N} AbstractArray{T,N}

typealias Indices{T<:Int} Union(Int, AbstractVector{T})


end # module
