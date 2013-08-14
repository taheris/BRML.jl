# Potential: structure for holding probability tables
abstract Potential

type PotArray <: Potential
    # variables: list of keys for each potential
    variables::Vector{Symbol}
    # table: probability of each state, initialised to 0
    table::Array{Real}
    # dimensions: maps a potential key to a dimension index
    dimensions::Dict{Symbol,Int}
    # domains: maps a potential key to a map from domain key to item index
    domains::Dict{Symbol,Dict{Symbol,Int}}

    # PotArray([:knife=>[:used,:notused],:maid=>[:murderer,:notmurderer],:butler=>[:murderer,:notmurderer]])
    function PotArray(domain::Dict{Symbol,Vector{Symbol}})
        variables = collect(keys(domain))
        dimensions = Dict{Symbol,Int}()
        domains = Dict{Symbol,Dict{Symbol,Int}}()
        tableDims = Array(Int, length(variables))
        
        for i=1:length(variables)
            key = variables[i]
            dom = domain[key]
            dimensions[key] = i
            domains[key] = [getindex(dom,j)=>j for j=1:length(dom)]
            tableDims[i] = length(dom)
        end

        table = zeros(tableDims...)
        new(variables, table, dimensions, domains) 
    end
end

# PotArray operations
size(p::PotArray) = size(p.table)
ndims(p::PotArray) = ndims(p.table)
length(p::PotArray) = length(p.table)
endof(p::PotArray) = endof(p.table)

# PotArray indexing
function subset(pot::PotArray, ind::Dict{Symbol,Symbol})
    # default to selecting all for each dimension
    items::Vector{Any} = [:(:) for i=1:ndims(pot)]

    for key in keys(ind)
        dim = pot.dimensions[key]
        item = pot.domains[key][ind[key]]
        # fix dimension of key at item value
        items[dim] = item
    end

    # return an expression object with selected subset of pot.table
    return Expr(:ref, pot.table, items...)
end

# getindex: used for 'pot[dict]' selection
function getindex(pot::PotArray, ind::Dict{Symbol,Symbol})
    return eval(subset(pot, ind))
end

# setindex!: used for 'pot[dict] = new_val' updating
function setindex!{T<:Real}(pot::PotArray, val::Union(T,Array{T}),
                            ind::Dict{Symbol,Symbol})
    # evaluate an expression object which sets subset equal to val
    eval(Expr(:(=), subset(pot, ind), :($val)))
    return val
end
