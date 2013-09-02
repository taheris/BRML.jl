# bar3z: plot a 3D bar plot of the matrix Z
bar3z(Z::NumArray) = mxcall(:bar3zcolor, 1, Z)

# chi2test: inverse of the chi square cumulative density
chi2test{T<:Real}(k::NumArray{T}, significance::Real) =
    mxcall(:chi2test, 1, float(k), significance)

# condexp: compute p proportional to exp(logp)
condexp(logp::NumVector) = condp(exp(logp - repmat(logp, 1, 1)))

function condexp(logp::NumMatrix)
    pmax = mapslices(max, logp, 1)
    P = size(logp, 1)
    return condp(exp(logp - repmat(pmax, P, 1)))
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

condp(pin::NumArray, i::Indices) = mxcall(:condp, 1, float(pin), i)

# drawNet: plot a network
function drawNet(Adj::SquareMatrix)
    adj = Adj.M
    @matlab cla
    @mput adj 
    return mxcall(:draw_layout, 3, adj)
end

drawNet(Adj::NumMatrix) = drawNet(SquareMatrix(Adj))

# gaussCond: return the mean and covariance of a conditioned Gaussian
gaussCond(obs::NumVector, meanAll::NumMatrix, sAll::SquareMatrix) =
    mxcall(:GaussCond, 2, float(obs), float(meanAll), float(sAll.M))

gaussCond(obs::NumVector, meanAll::NumMatrix, sAll::NumMatrix) =
    gaussCond(obs, meanAll, SquareMatrix(sAll))
    
# plotCov: returns points for plotting an ellipse of a covariance
plotCov(mean::NumMatrix, covariance::SquareMatrix, length::Real) =
    mxcall(:plotCov, 1, float(mean), float(covariance.M), float(length))

plotCov(mean::NumMatrix, covariance::NumMatrix, length::Real) =
    plotCov(mean, SquareMatrix(covariance), length)

# stateCount: return state counts for a data matrix where each column is a datapoint
function stateCount(data::NumMatrix, states::NumArray)
    data = float(data)
    states = float(states)
    
    @mput data states
    eval_string("[cidx states] = count(data, states);")
    @mget cidx states;
    
    return cidx, states
end
