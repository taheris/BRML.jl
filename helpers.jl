function isvector(A::AbstractArray)
    if ndims(A) == 1 || ndims(A) == 2 && (size(A, 1) == 1 || size(A, 2) == 1)
        true
    else
        false
    end
end
