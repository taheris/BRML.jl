using FactCheck
using Graphs
#using BRML # remove b.


facts("Testing Graphs") do
    dg = b.DirectedIntGraph(4)
    ug = b.UndirectedIntGraph(4)
    es = [Edge(1,1,2), Edge(2,1,3), Edge(3,2,3), Edge(4,2,4), Edge(5,3,4)]

    for edge in es
        add_edge!(dg, edge.source, edge.target)
        add_edge!(ug, edge.source, edge.target)
    end
   
    context("Adjacency Matrix") do
        adjM = falses(4,4)
        adjM[1,2] = adjM[1,3] = adjM[2,3] = adjM[2,4] = adjM[3,4] = true

        @fact Graphs.adjacency_matrix_by_adjlist(g) => adjM
    end

    context("Parents") do
        @fact b.parents(dg, 1) => []
        @fact b.parents(dg, 2) => [1]
        @fact b.parents(dg, 3) => [1,2]
        @fact b.parents(dg, 4) => [2,3]
        @fact b.parents(dg, [2,3]) => [1,2]
    end

    context("Ancestors") do
        @fact b.ancestors(dg, [2,3]) => [1]
        @fact b.ancestors(dg, 4) => [1,2,3]
    end

    context("Children") do
        @fact b.children(dg, 1) => [2,3]
        @fact b.children(dg, [2,3]) => [3,4]
    end

    context("Neighbours") do
        @fact b.neighbours(ug, 1) => [2,3]
        @fact b.neighbours(ug, 2) => [1,3,4]
        @fact b.neighbours(ug, 3) => [1,2,4]
        @fact b.neighbours(ug, 4) => [2,3]
    end
end
