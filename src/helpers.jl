# indval: applies index and value functions to an argument
indval(ind::Function, val::Function, a::Number) = ind(a), val(a)
indval(ind::Function, val::Function, A::NumVector) = ind(A), val(A)
indval(ind::Function, val::Function, A::NumMatrix) =
    mapslices(ind, A, 1), mapslices(val, A, 1)

# isvector: one matrix dimension is of size 1
function isvector(A::AbstractMatrix)
    if ndims(A) == 1 || ndims(A) == 2 && (size(A, 1) == 1 || size(A, 2) == 1)
        return true
    else
        return false
    end
end
