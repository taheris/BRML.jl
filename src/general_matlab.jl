using PyCall

include("helpers.jl")

@pyimport numpy.random as npr
@pyimport scipy.special as sps


# bar3z: plot a 3D bar plot of the matrix Z
bar3z(Z::NumArray) = mxcall(:bar3zcolor, 1, Z)

# chi2test: inverse of the chi square cumulative density
chi2test{T<:Real}(k::NumArray{T}, significance::Real) =
    mxcall(:chi2test, 1, float(k), significance)

# stateCount: return state counts for a data matrix where each column is a datapoint
function stateCount(data::NumMatrix, states::NumArray)
    @mput data states
    @matlab begin
        # convert to double to avoid combination error with rem function
        [cidx states] = count(double(data), double(states))
    end
    @mget cidx states
    return cidx, states
end

# condp: make a conditional distribution from an array
function condp(pin::NumVector)
    m = max(pin) 
    p = m > 0 ? pin ./ m : pin + eps
    return bsxfun(./, p, sum(p)) 
end

function condp(pin::NumMatrix)
    m = max(pin)
    p = m > 0 ? pin ./ m : pin + eps
    return bsxfun(./, p, mapslices(sum,p,1))
end

condp(pin::NumArray, i::Indices) = mxcall(:condp, 1, pin, i)
