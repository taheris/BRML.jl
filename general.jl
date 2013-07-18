function argmax(A::AbstractArray)
    if isempty(A)
        error("argmax: array is empty")
    end
    argf(findmax, A)
end

function argmin(A::AbstractArray)
    if isempty(A)
        error("argmin: array is empty")
    end
    argf(findmin, A)
end

function argf{T<:Any}(f::Function, A::AbstractArray{T, 1})
    return f(A)
end

function argf{T<:Any}(f::Function, A::AbstractArray{T, 2})
    if size(A)[1] == 1 || size(A)[2] == 1
        return f(vec(A))
    else
        rows, cols = size(A)
        vals = Array(T, cols)
        inds = Array(Int32, cols)
        for i=1:cols
            val, ind = f(slicedim(A,2,i))
            vals[i] = val
            inds[i] = ind
        end
        return vals, inds
    end
end
