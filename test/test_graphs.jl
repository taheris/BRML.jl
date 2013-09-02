using FactCheck
using Graphs
using BRML


facts("Testing Graphs") do
    dg = DirectedIntGraph(4)
    ug = UndirectedIntGraph(4)
    es = [Edge(1,1,2), Edge(2,1,3), Edge(3,2,3), Edge(4,2,4), Edge(5,3,4)]

    for edge in es
        add_edge!(dg, edge.source, edge.target)
        add_edge!(ug, edge.source, edge.target)
    end

    context("Adjacency Matrix") do
        adjM = falses(4,4)
        adjM[1,2] = adjM[1,3] = adjM[2,3] = adjM[2,4] = adjM[3,4] = true

        @fact Graphs.adjacency_matrix_by_adjlist(dg) => adjM
    end

    context("Parents") do
        @fact parents(dg, 1) => []
        @fact parents(dg, 2) => [1]
        @fact parents(dg, 3) => [1,2]
        @fact parents(dg, 4) => [2,3]
        @fact parents(dg, [2,3]) => [1,2]
    end

    context("Ancestors") do
        @fact ancestors(dg, [2,3]) => [1]
        @fact ancestors(dg, 4) => [1,2,3]
    end

    context("Children") do
        @fact children(dg, 1) => [2,3]
        @fact children(dg, [2,3]) => [3,4]
    end

    context("Neighbours") do
        @fact neighbours(ug, 1) => [2,3]
        @fact neighbours(ug, 2) => [1,3,4]
        @fact neighbours(ug, 3) => [1,2,4]
        @fact neighbours(ug, 4) => [2,3]
    end
end
