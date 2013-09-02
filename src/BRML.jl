module BRML

# if a MATLAB environment is available, change boolean to use MATLAB functions
const use_matlab = false

# dependencies
using PyCall
using Graphs
using Iterators

# extend methods
importall Base
importall Graphs

export
    # types.jl
    NumVector, NumMatrix, NumArray, SquareMatrix,

    # potential.jl
    Potential, PotArray, varType, domType, sumpot,

    # helpers.jl
    indval, isvector, vectorIndex,

    # graphs.jl
    DirectedGraph, UndirectedGraph, DirectedIntGraph, UndirectedIntGraph,
    push_edge!, parents, ancestors, find_ancestors, children, neighbours,

    # general.jl
    argmin, argmax, logsumexp, betaXGreaterBetaY, avgSigmaGauss, cap, dirRand,
    multiVarRandN, normP, sigma

include("types.jl")
include("potential.jl")
include("helpers.jl")
include("graphs.jl")
include("general.jl")

if use_matlab
    using MATLAB

    export
        # general_matlab.jl
        bar3z, chi2test, condexp, condp, drawNet, gaussCond, plotCov, stateCount,

        # demos_matlab.jl
        demoGibbsGauss

    include("matlab.jl")
    include("general_matlab.jl")
    include("demos_matlab.jl")
end

end # module
