# Potential: structure for holding probability tables
abstract Potential

type PotArray{VT,DT} <: Potential
    # variables: list of identifiers for each variable in potential
    variables::Vector{VT}
    # dimension: maps an identifier to a table dimension index
    dimension::Dict{VT,Int}
    # domain: maps a variable identifer to a list of domain values
    domain::Dict{VT,Vector{DT}}
    # table: probability of each state
    table::Array{Float64}
end

# Constructor from an ordered list of variables, with a probability table
# where the dimension order matches the variable order, and a map from each
# variable to a list of domain values of size equal to the table dimension
function PotArray{VT,DT}(variables::Vector{VT}, table::Array{Float64},
                         domain::Dict{VT,Vector{DT}})
    vlen = length(variables)
    dims = size(table)
    dlen = length(keys(domain))
    if vlen != dlen
        error("The number of domain keys must equal the number of variables")
    end

    dimension = Dict{VT,Int}()
    for i = 1:vlen
        var = variables[i]
        dom = domain[var]
        if dims[i] != length(dom)
            error("Variable $(var) on table dimension $(i) doesn't match domain size")
        end
        dimension[var] = i
    end

    return PotArray(variables, dimension, domain, table) 
end

# Constructor without defined domains, which will default to sequential ints
function PotArray{VT}(variables::Vector{VT}, table::Array{Float64})
    dims = size(table)
    domain::Dict{VT,Vector{Int}}()

    for i = 1:length(variables)
        var = variables[i]
        domain[var] = [1:dims[i]]
    end

    return PotArray(variables, table, domain)
end

# Constructor without table of probabilities, which will be initiliased to zeros
function PotArray{VT,DT}(variables::Vector{VT}, domain::Dict{VT,Vector{DT}})
    vlen = length(variables)
    tableDims = Array(Int, vlen)

    for i = 1:vlen
        var = variables[i]
        dom = domain[var]
        tableDims[i] = length(dom)
    end

    table = zeros(tableDims...)
    return PotArray(variables, table, domain)
end

# PotArray operations
size(pot::PotArray) = size(pot.table)
size(pot::PotArray, dim::Int) = size(pot.table, dim)
ndims(pot::PotArray) = ndims(pot.table)
length(pot::PotArray) = length(pot.table)
endof(pot::PotArray) = endof(pot.table)

# PotArray type functions
variableType{VT,DT}(pot::PotArray{VT,DT}) = VT
domainType{VT,DT}(pot::PotArray{VT,DT}) = DT

# domainIndex: return the index position of a domain value, or -1 if not found
function domainIndex{DT}(domain::Vector{DT}, val::DT)
    for i = 1:length(domain)
        if domain[i] == val
            return i
        end
    end
    return -1
end

# getindex: allows 'pot[val1,:,val3]' retrieval, returning a new pot of
# variable var2 where var1 = val1 and var3 = val3 from the original pot
function getindex(pot::PotArray, vals...)
    vlen = length(pot.variables)
    if length(vals) != vlen
        error("Number of values must equal number of variables")
    end

    vt = variableType(pot)
    dt = domainType(pot)
    variables = Array(vt, 0)
    domain = Dict{vt,Vector{dt}}()
    indices = Array(Int, vlen)
    
    for i = 1:length(vals)
        val = vals[i]
        var = pot.variables[i]
        dom = pot.domain[var]
        indices[i] = domainIndex(dom, val)
        
        if val == 1:length(dom) 
            push!(variables, var)
            domain[var] = dom
        end
    end

    if !any([i == -1 for i in indices])
        return pot.table[indices...]
    end
        
    newpot = PotArray(variables, domain)
    
    return newpot
end

getindex{VT,DT}(pot::PotArray, varVal::(VT,DT)) = getindex(pot, [varVal])

# PotArray table selection
function subset{VT,DT}(pot::PotArray, varVal::Vector{(VT,DT)})
    # default to selecting all for each dimension
    items::Vector{Any} = [:(:) for i=1:ndims(pot)]

    for i = 1:length(varVal)
        var, val = varVal[i]
        dim = pot.dimension[var]
        item = pot.domain[var][val]

        # fix dimension of var at item value
        items[dim] = item
    end

    # return an expression object with selected subset of pot.table
    return Expr(:ref, pot.table, items...)
end

# setindex!: allows 'pot[[(var1, val1), (var2, val2)]]' = newVals' updating,
# selecting where var1 = val1 and var2 = val2 and setting the result to newVal
function setindex!{VT,DT}(pot::PotArray, newVal::Union(Float64,Array{Float64}),
                          varVal::Vector{(VT,DT)})
    # evaluate an expression object which sets subset equal to new_val
    eval(Expr(:(=), subset(pot, varVal), :($newVal)))
    return newVal
end

setindex!{VT,DT}(pot::PotArray, newVal::Union(Float64,Array{Float64}), varVal::(VT,DT)) =
    setindex!(pot, newVal, [varVal])

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
