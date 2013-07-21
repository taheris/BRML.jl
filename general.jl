include("helpers.jl")


using PyCall
using Debug


@pyimport scipy.special as sp


function argmax(A)
    if isempty(A)
        error("argmax: array is empty")
    end
    argf(indmax,max,A)
end

function argmin(A)
    if isempty(A)
        error("argmin: array is empty")
    end
    argf(indmin,min,A)
end

function argf(ind::Function, val::Function, A::Any)
    return ind(A), val(A)
end

function argf(ind::Function, val::Function, A::AbstractArray)
    if isvector(A)
        a = vec(A)
        return ind(a), val(a)
    else
        return mapslices(ind,A,1), mapslices(val,A,1)
    end
end

function logsumexp(A::AbstractArray, b::Number=1)
    logsumexp(A, b*ones(size(A)))
end

function logsumexp(A::AbstractArray, B::AbstractArray)
    if isvector(A)
        max_val = max(A)
        exp_diff = exp(A - max_val)
        return max_val + log(sum(exp_diff .* B))
    else
        max_val = mapslices(max, A, 1)
        rep_max = repmat(max_val, size(A,1), 1)
        exp_diff = exp(A - rep_max)
        return max_val + log(mapslices(sum, exp_diff .* B, 1))
    end
end

function betaXGreaterBetaY(xAlpha::Real, xBeta::Real, yAlpha::Real, yBeta::Real,
                           delta::Real=0.0001)
    # p(x>y) for x~Beta(xAlpha, xBeta), y~Beta(yAlpha, yBeta)
    x = [0:delta:1]
    p = delta * sum(x .^ (xAlpha-1) .* (1-x) .^ (xBeta-1)
                    .* sp.betainc(x,yAlpha,yBeta)) / beta(xAlpha, xBeta)
    m = (log(delta) + (xAlpha-1)*log(x) + (xBeta-1)*log(1-x)
         + log(sp.betainc(x,yAlpha,yBeta)) - sp.betaln(xAlpha,xBeta))
    return p, logsumexp(m)
end
