# Potential: structure for holding probability tables
abstract Potential

type PotArray <: Potential
    # variables: list of keys for each potential
    variables::Vector{Symbol}
    # table: probability of each state, initialised to 0
    table::Array
    # dimensions: maps a potential key to a dimension index
    dimensions::Dict{Symbol,Int}
    # domains: maps a potential key to a map from domain key to item index
    domains::Dict{Symbol,Dict{Symbol,Int}}
end

# PotArray: constructor from a map of keys to a list of domain keys
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
    return PotArray(variables, table, dimensions, domains) 
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

function *(A::PotArray, B::PotArray)
    variables = Symbol[]
    dimensions = Dict{Symbol,Int}()
    dimension = 1
    domains = Dict{Symbol,Dict{Symbol,Int}}()
    tableDims = Int[]
    
    for dom in (A.domains, B.domains)
        for key in keys(dom)
            if contains(variables, key)
                error("Duplicate key: $(string(key))")
            end
            push!(variables, key)
            dimensions[key] = dimension
            dimension += 1
            domains[key] = dom[key]
            push!(tableDims, length(dom[key]))
        end
    end

    table = zeros(tableDims...)
    newpot = PotArray(variables, table, dimensions, domains)
    
    for keyA in keys(A.domains), keyB in keys(B.domains)
        for domA in keys(A.domains[keyA]), domB in keys(B.domains[keyB])
            newpot[[keyA=>domA, keyB=>domB]] = A[[keyA=>domA]] * B[[keyB=>domB]]
        end
    end

    return newpot
end
