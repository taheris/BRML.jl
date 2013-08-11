module BRML

using MATLAB
using PyCall
using Debug

importall Base # extend Base methods
import Base.LinAlg: DimensionMismatch

export
    # types.jl
    NumVector, NumMatrix, NumArray, SquareMatrix,

    # helpers.jl
    indval, isvector,

    # general.jl
    argmin, argmax, logsumexp, betaXGreaterBetaY, avgSigmaGauss, cap,
    condexp, dirRand, multivarRandN, sigma,

    # general_matlab.jl
    bar3z, chi2test, condp, gaussCond, plotCov, stateCount,
    
    # demos.jl
    demoGibbsGauss

include("matlab.jl")
include("types.jl")
include("helpers.jl")
include("general.jl")
include("general_matlab.jl")
include("demos.jl")

end # module

b = BRML
