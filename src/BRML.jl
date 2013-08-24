module BRML

# dependencies
using MATLAB
using PyCall
using Graphs
using Iterators
using Debug

# extend methods
importall Base
importall Graphs

export
    # types.jl
    NumVector, NumMatrix, NumArray, SquareMatrix,

    # potential.jl
    Potential, PotArray, varType, domType, sumpot,

    # helpers.jl
    indval, isvector,

    # graphs.jl
    DirectedGraph, UndirectedGraph, DirectedIntGraph, UndirectedIntGraph,
    push_edge!, parents, ancestors, find_ancestors, children, neighbours,

    # general.jl
    argmin, argmax, logsumexp, betaXGreaterBetaY, avgSigmaGauss, cap,
    condexp, dirRand, multiVarRandN, normP, sigma,

    # general_matlab.jl
    bar3z, chi2test, condp, drawNet, gaussCond, plotCov, stateCount,

    # demos_matlab.jl
    demoGibbsGauss

include("matlab.jl")
include("types.jl")
include("potential.jl")
include("helpers.jl")
include("graphs.jl")
include("general.jl")
include("general_matlab.jl")
include("demos_matlab.jl")

end # module

b = BRML
