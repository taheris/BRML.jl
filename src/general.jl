@pyimport numpy.random as npr
@pyimport scipy.special as sps


# argmin/argmax: returns a tuple of positions and values
# at a minimum/maximum in dimension 1
argmin(A) = indval(indmin, min, A)
argmax(A) = indval(indmax, max, A)

# logsumexp: computes log(sum(exp(a) .* b))
logsumexp(a::Number, b::Number=1) = logsumexp([a], [b])
logsumexp(A::NumArray, b::Number=1) = logsumexp(A, b*ones(size(A)))
logsumexp(A::NumVector, B::NumVector) = max(A) + log(sum(exp(A-max(A)) .* B))

function logsumexp(A::NumMatrix, B::NumMatrix)
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
cap(x::NumArray, c::Number) = begin
    out = copy(x)
    indices = find(abs(out) .> c)
    out[indices] = c * sign(out[indices])
    return out
end

#function chi2test{T<:Real}(k::NumMatrix{T}, significance::Real,
#                           range::NumVector=[0:0.1:1000]')
#    out = Array(eltype(k), (1,length(k)))
#    for i = 1:length(k)
#        y = condexp((k[i]/2 - 1) .* log(range+eps()) - range/2)
#        indices = find(cumsum(y) .> 1 - significance)
#        out[i] = range[indices[1]]
#    end
#    return out
#end

# condexp: compute p proportional to exp(logp)
condexp(logp::NumVector) = condp(exp(logp - repmat(logp, 1, 1)))

function condexp(logp::NumMatrix)
    pmax = mapslices(max, logp, 1)
    P = size(logp, 1)
    return condp(exp(logp - repmat(pmax, P, 1)))
end

# dirRand: draw n samples from a Dirichlet distribution
function dirRand(alpha::NumVector, n::Number)
    r = zeros(length(alpha), n)
    for k = 1:length(alpha)
        r[k, :] = npr.gamma(alpha[k], 1, n)
    end
    return r ./ repmat(mapslices(sum,r,1), length(alpha), 1)
end

# multivarRandN: samples from a multi-variate Normal(Gaussian) distribution
multivarRandN(mu::Real, sigma::Real, cases::Int=1) = multivarRandN([mu], sigma, cases)

function multivarRandN(mu::NumVector, sigma::Real, cases::Int=1)
    U,S,V = svd(sigma)
    r = randn(length(mu), cases)
    return U*diagm(sqrt(vec(diagm(S)))).*r + repmat(mu,1,cases)
end

# sigma: returns 1 ./ (1+exp(-x))
sigma(x::NumArray) = 1 ./ (1+exp(-x))
