module BRML

# dependencies
using MATLAB
using PyCall
using Graphs
using Debug

# extend methods
importall Base
importall Graphs

export
    # types.jl
    NumVector, NumMatrix, NumArray, SquareMatrix,

    # potential.jl
    Potential, PotArray,

    # helpers.jl
    indval, isvector,

    # general.jl
    argmin, argmax, logsumexp, betaXGreaterBetaY, avgSigmaGauss, cap,
    condexp, dirRand, multiVarRandN, normP, sigma,

    # general_matlab.jl
    bar3z, chi2test, condp, drawNet, gaussCond, plotCov, stateCount,
    
    # graphs.jl
    DirectedGraph, UndirectedGraph, DirectedIntGraph, UndirectedIntGraph,
    is_directed, num_vertices, vertices, num_edges, edges, vertex_index,
    edge_index, out_degree, out_neighbors, out_edges, add_vertex!, add_edge!,
    push_edge!, parents, ancestors, find_ancestors, children, neighbours,

    # demos.jl
    demoGibbsGauss

include("matlab.jl")
include("types.jl")
include("potential.jl")
include("helpers.jl")
include("general.jl")
include("general_matlab.jl")
include("graphs.jl")
include("demos.jl")

end # module

b = BRML
