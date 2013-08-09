module BRML

include("matlab.jl")
include("types.jl")
include("general.jl")
include("general_matlab.jl")

export
    # general.jl
    argmin, argmax, logsumexp, betaXGreaterBetaY, avgSigmaGauss, cap,
    condexp, dirRand,

    # general_matlab.jl
    bar3z, chi2test, condp, stateCount

end # module
