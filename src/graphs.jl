# define new graph types based on the Graphs.jl library
for graph_type in (:directedgraph, :undirectedgraph)
    @eval begin
        # define directedgraph and undirectedgraph types
        type ($graph_type){v,e,vlist,elist,adjlist,inclist} <: abstractgraph{v,e}
            vertices::vlist
            edges::elist
            adjlist::adjlist
            inclist::inclist
        end

        # define constructors
        function ($graph_type){V,E}(vtype::Type{V}, etype::Type{E})
            vertices = V[]
            edges = E[]
            adjlist = Vector{V}[]
            inclist = Vector{E}[]
            ($graph_type){V,E,Vector{V},Vector{E},Vector{Vector{V}},Vector{Vector{E}}}
                (vertices, edges, adjlist, inclist)    
        end

        # define interface implementations
        @graph_implements ($graph_type) vertex_list edge_list vertex_map edge_map adjacency_list incidence_list
        
        # implement interface functions
        num_vertices(g::($graph_type)) = length(g.vertices)
        vertices(g::($graph_type)) = g.vertices

        num_edges(g::($graph_type)) = length(g.edges)
        edges(g::($graph_type)) = g.edges

        vertex_index(v, g::($graph_type)) = vertex_index(v)
        edge_index(e, g::($graph_type)) = edge_index(e)

        out_degree(v, g::($graph_type)) = length(g.adjlist[vertex_index(v)])
        out_neighbors(v, g::($graph_type)) = g.adjlist[vertex_index(v)]
        out_edges(v, g::($graph_type)) = g.inclist[vertex_index(v)]

        # define mutation functions
        function add_vertex!{V,E}(g::($graph_type){V,E}, vertex::V)
            vi = vertex_index(vertex)

            if vi != length(g.vertices) + 1
                throw(ArgumentError("Invalid vertex index."))
            end

            push!(g.vertices, vertex)
            push!(g.adjlist, V[])
            push!(g.inclist, E[])

            return v
        end

        add_vertex!{K}(g::($graph_type){KeyVertex{K}}, key::K) =
            add_vertex!(g, KeyVertex(length(g.vertices)+1, key))
        add_vertex!(g::($graph_type){ExVertex}, label::String) =
            add_vertex!(g, ExVertex(length(g.vertices)+1, label))

        function add_edge!{V,E}(g::($graph_type){V,E}, edge::E)
            nv = num_vertices(g) 

            u = source(edge)
            v = target(edge)
            ui = vertex_index(u, g)
            vi = vertex_index(v, g)
            if !(ui >= 1 && ui <= nv && vi >= 1 && vi <= nv)
                throw(ArgumentError("u or v is not a valid vertex."))
            end

            ei = length(g.edges) + 1
            if edge_index(edge) != ei
                throw(ArgumentError("Invalid edge index."))
            end

            push_edge!(g, edge, u, v, ui, vi)

            return edge
        end

        add_edge!{V}(g::($graph_type){V,Edge{V}}, u::V, v::V) =
            add_edge!(g, Edge{Int}(length(g.edges)+1, u, v))
        add_edge!{V}(g::($graph_type){V,ExEdge{V}}, u::V, v::V) =
            add_edge!(g, ExEdge{V}(length(g.edges)+1, u, v))
    end
end

# push_edge!: auxiliary function for add_edge!
function push_edge!{V,E}(g::DirectedGraph, edge::E, u::V, v::V, ui::Int, vi::Int)
    push!(g.edges, edge)
    push!(g.adjlist[ui], v)
    push!(g.inclist[ui], edge)
end

function push_edge!{V,E}(g::UndirectedGraph, edge::E, u::V, v::V, ui::Int, vi::Int)
    push!(g.edges, edge)
    push!(g.adjlist[ui], v)
    push!(g.inclist[ui], edge)
    push!(g.adjlist[vi], u)   
    push!(g.inclist[vi], revedge(edge))
end

# type aliases for directed and undirected integer graphs
typealias DirectedIntGraph DirectedGraph{Int,Edge{Int},Range1{Int},Vector{Edge{Int}},
                                         Vector{Vector{Int}},Vector{Vector{Edge{Int}}}}
typealias UndirectedIntGraph UndirectedGraph{Int,Edge{Int},Range1{Int},Vector{Edge{Int}},
                                             Vector{Vector{Int}},Vector{Vector{Edge{Int}}}}

for graph_type in (:DirectedIntGraph, :UndirectedIntGraph)
    @eval begin
        # define constructors
        function ($graph_type)(size::Int)
            vertices = 1:size
            edges = Edge{Int}[]
            adjlist = Array(Vector{Int}, size)
            inclist = Array(Vector{Edge{Int}}, size)

            for i = 1:size
                adjlist[i] = Int[]
                inclist[i] = Edge{Int}[]
            end

            ($graph_type)(vertices, edges, adjlist, inclist)
        end
    end 
end

# is_directed: boolean used to complete AbstractGraph implementation
is_directed(g::DirectedGraph) = true
is_directed(g::UndirectedGraph) = false

# parents: returns the parents of each vertex in vs for a directed graph g
function parents{V,E}(g::DirectedGraph{V,E}, vs::Array{V})
    parents = V[]

    for edge in edges(g)
        if contains(vs, target(edge))
            push!(parents, source(edge))
        end
    end
    
    return sort(unique(parents))
end

parents{V,E}(g::DirectedGraph{V,E}, vertex::V) = parents(g, [vertex])

# ancestors: return the vertices with a path to any vertex in vs
ancestors{V,E}(g::DirectedGraph{V,E}, vs::Array{V}) =
    sort(setdiff(find_ancestors(g, vs, V[]), vs))

ancestors{V,E}(g::DirectedGraph{V,E}, vertex::V) = ancestors(g, [vertex])

# find_ancestors: recursively find parents until there are no new vertices
function find_ancestors{V,E}(g::DirectedGraph{V,E}, vs::Array{V}, found::Array{V})
    ancestors = parents(g, vs)
    
    if isempty(setdiff(ancestors, found))
        return unique(found)
    else
        return find_ancestors(g, ancestors, union(found, ancestors))
    end
end

# children: find the children of a list of vertices
function children{V,E}(g::DirectedGraph{V,E}, vs::Array{V})
    children = V[]

    for edge in edges(g)
        if contains(vs, source(edge))
            push!(children, target(edge))
        end
    end
    
    return sort(unique(children))
end

children{V,E}(g::DirectedGraph{V,E}, vertex::V) = children(g, [vertex])

# neighbours: return the neighbours of vertex v on a graph g
neighbours{V,E}(g::UndirectedGraph{V,E}, v::V) = out_neighbors(v, g)
