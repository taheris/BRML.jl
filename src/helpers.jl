# indval: applies index and value functions to an argument
indval(ind::Function, val::Function, a::Number) = ind(a), val(a)
indval(ind::Function, val::Function, A::NumVector) = ind(A), val(A)
indval(ind::Function, val::Function, A::NumMatrix) =
    mapslices(ind, A, 1), mapslices(val, A, 1)

# isvector: one matrix dimension is of size 1
isvector(A::AbstractMatrix) = size(A, 1) == 1 || size(A, 2) == 1

# vectorIndex: return the index position of a specific vector value
function vectorIndex{T}(vector::Vector{T}, val::T)
    for i = 1:length(vector)
        if vector[i] == val
            return i
        end
    end
    error("Value $(val) not found")
end
