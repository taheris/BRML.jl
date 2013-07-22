#module General

using PyCall
using Debug

@pyimport scipy.special as sps

include("helpers.jl")


# argmin/argmax: returns a tuple of positions and values
# at a minimum/maximum in dimension 1
argmin(A) = indval(indmin, min, A)
argmax(A) = indval(indmax, max, A)

# indval: applies index and value functions to an argument
indval(ind::Function, val::Function, a::Number) = ind(a), val(a)
indval(ind::Function, val::Function, A::AbstractVector) = ind(A), val(A)
indval(ind::Function, val::Function, A::AbstractArray) =
    mapslices(ind, A, 1), mapslices(val, A, 1)

# logsumexp: computes log(sum(exp(a) .* b))
logsumexp(a::Number, b::Number=1) = logsumexp([a], [b])
logsumexp(A::AbstractArray, b::Number=1) = logsumexp(A, b*ones(size(A)))
logsumexp(A::AbstractVector, B::AbstractArray) = begin
    max_val = max(A)
    exp_diff = exp(A - max_val)
    return max_val + log(sum(exp_diff .* B))
end
logsumexp(A::AbstractArray, B::AbstractArray) = begin
    max_vals = mapslices(max, A, 1)
    rep_max = repmat(max_vals, size(A,1), 1)
    exp_diff = exp(A - rep_max)
    return max_vals + log(mapslices(sum, exp_diff .* B, 1))
end

# betaXGreaterBetaY: p(x>y) for x~Beta(xAlpha, xBeta), y~Beta(yAlpha, yBeta)
function betaXGreaterBetaY(xAlpha::Real, xBeta::Real, yAlpha::Real, yBeta::Real,
                           delta::Real=0.0001)
    x = [0:delta:1]
    p = delta * sum(x .^ (xAlpha-1) .* (1-x) .^ (xBeta-1)
                    .* sps.betainc(x,yAlpha,yBeta)) / beta(xAlpha, xBeta)
    m = (log(delta) + (xAlpha-1)*log(x) + (xBeta-1)*log(1-x)
         + log(sps.betainc(x,yAlpha,yBeta)) - sp.betaln(xAlpha,xBeta))
    return p, logsumexp(m)
end

# avgSigmaGauss: average of a logistic sigmoid under a Gaussian
function avgSigmaGauss(mean::Real, variance::Real)
    erflambda = sqrt(pi) / 4
    return 0.5 + 0.5erf(erflambda * mean / sqrt(1 + 2erflambda^2 * variance))
end

# cap: limits each x item to an absolute value c
cap(x::Number, c::Number) = abs(x) > c ? c*sign(x) : x
cap(x::AbstractArray, c::Number) = begin
    out = copy(x)
    indices = find(abs(out) .> c)
    out[indices] = c * sign(out[indices])
    return out
end

# chi2test: inverse of the chi square cumulative density
# TODO: incomplete
function chi2test{T<:Real}(k::AbstractArray{T}, significance::Real,
                           range::AbstractVector=[0:0.1:1000]')
    out = Array(eltype(k), (1,length(k)))
    for i = 1:length(k)
        y = condexp((k[i]/2 - 1) .* log(range+eps()) - range/2)
        indices = find(cumsum(y) .> 1 - significance)
        out[i] = range[indices[1]]
    end
    return out
end

# condexp: compute p proportional to exp(logp)
condexp(logp::Number) = condexp([logp])
function condexp{T<:Real}(logp::AbstractArray{T})
    pmax = [mapslices(max, logp, 1)]
    P = size(logp, 1)
    return condp(exp(logp - repmat(pmax, P, 1)))
end

# condp: make a conditional distribution from an array
function condp(pin::AbstractArray)
    m = max(pin)
    p = m > 0 ? pin ./ m : pin + eps
    if isvector(pin)
        return bsxfun(./, p, sum(p)) 
    else
        return bsxfun(./, p, mapslices(sum,p,1))
    end
end

#function count(data::AbstractArray, states::Number)

#ind2subv: subscript vector from linear index
function ind2subv(arraySize::AbstractArray, index::AbstractArray)
    k = [1 cumprod(arraySize[1:end-1])]
    out = Array(eltype(index), size(index))
    for i = length(arraySize):-1:1
        vi = rem(index-1, k[i]) + 1
        vj = (index - vi) ./ k[i] + 1
        out[:, i] = vj
        index = vi
    end
    return out
end

#end # module
