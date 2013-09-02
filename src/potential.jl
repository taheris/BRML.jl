# Potential: structure for holding probability tables
abstract Potential

type PotArray{VT,DT} <: Potential
    # variables: list of identifiers for each variable in potential
    variables::Vector{VT}
    # dimension: maps an identifier to a table dimension index
    dimension::Dict{VT,Int}
    # domain: maps an identifer to a list of domain values
    domain::Dict{VT,Vector{DT}}
    # table: probability of each state
    table::Array{Float64}

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
                error("Variable $(var) on dimension $(i) doesn't match domain size")
            end
            dimension[var] = i
        end

        return new(variables, dimension, domain, table) 
    end
end

# Use inner constructor
function PotArray{VT,DT}(variables::Vector{VT}, table::Array{Float64},
                         domain::Dict{VT,Vector{DT}})
    return PotArray{VT,DT}(variables, table, domain)
end

# Constructor without defined domains, which will default to sequential ints
function PotArray{VT}(variables::Vector{VT}, table::Array{Float64})
    dims = size(table)
    domain = Dict{VT,Vector{Int}}()

    for i = 1:length(variables)
        var = variables[i]
        domain[var] = [1:dims[i]]
    end

    return PotArray{VT,Int}(variables, table, domain)
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
    return PotArray{VT,DT}(variables, table, domain)
end

# PotArray operations
size(pot::PotArray) = size(pot.table)
size(pot::PotArray, dim::Int) = size(pot.table, dim)
ndims(pot::PotArray) = ndims(pot.table)
length(pot::PotArray) = length(pot.table)
endof(pot::PotArray) = endof(pot.table)

# PotArray type functions
varType{VT,DT}(pot::PotArray{VT,DT}) = VT
domType{VT,DT}(pot::PotArray{VT,DT}) = DT

# getindex: allows 'pot[val1,:,val3]' retrieval, returning a new pot with
# variable var2 where var1 = val1 and var3 = val3 from the original pot.
# If there are no missing indices, getindex returns the state probability value.
function getindex{VT,DT}(pot::PotArray{VT,DT}, vals...)
    indices = domainIndices(pot, vals...)

    if any([index == 0 for index in indices])
        return missingPot(pot, indices, vals...)
    else
        return pot.table[indices...]
    end
end

# setindex!: allows 'pot[val1,val2]' = x' updating, setting the potential
# table state where var1 = val1 and var2 = val2 to new probability x
function setindex!{VT,DT}(pot::PotArray{VT,DT}, x::Float64, vals...)
    indices = domainIndices(pot, vals...)

    if any([index == 0 for index in indices])
        error("Cannot set state probability with range values")
    else
        pot.table[indices...] = x
    end
end

# domainIndices: return an array of index positions for each pot variable
function domainIndices{VT,DT}(pot::PotArray{VT,DT}, vals...)
    vlen = length(pot.variables)
    if length(vals) != vlen
        error("Number of values must equal number of variables")
    end

    indices = Array(Int, vlen)
    for i = 1:vlen
        val = vals[i]
        if isa(val, VT)
            var = pot.variables[i]
            dom = pot.domain[var]
            indices[i] = vectorIndex(dom, val)
        elseif isa(val, Range1)
            indices[i] = 0
        else
            error("Not a valid variable domain: $(val)")
        end 
    end

    return indices
end

# newPot: create a new potential containing the missing values in indices
function missingPot{VT,DT}(pot::PotArray{VT,DT}, indices::Vector{Int}, vals...)
    vlen = length(vals)
    missingIndex = Int[]
    variables = VT[]
    domain = Dict{VT,Vector{DT}}()

    for i = 1:vlen
        if indices[i] == 0
            var = pot.variables[i]
            dom = pot.domain[var]
            push!(missingIndex, i)
            push!(variables, var)
            domain[var] = dom
        end
    end

    mlen = length(missingIndex)
    newPot = PotArray(variables, domain)
    newDomains = [newPot.domain[var] for var in variables]

    for newVals in Iterators.product(newDomains...)
        for i = 1:mlen
            ind = missingIndex[i]
            val = newVals[i]
            var = newPot.variables[i]
            dom = newPot.domain[var]
            indices[ind] = vectorIndex(dom, val)
        end
        newPot[newVals...] = pot.table[indices...]
    end
    
    return newPot
end

# *: Multiply two potentials together, returning a new potential.
# If A is a potential over variables 1 and 2, and B is a potential over
# variables 1 and 3, the result will be a potential over variables 1, 2 and 3.
function *{VT,DT}(A::PotArray{VT,DT}, B::PotArray{VT,DT})
    variables = union(A.variables, B.variables)
    vlen = length(variables)
    domain = Dict{VT,Vector{DT}}()

    for i = 1:vlen
        var = variables[i]
        domain[var] = contains(A.variables, var) ? A.domain[var] : B.domain[var]
    end

    pot = PotArray(variables, domain)
    domains = [pot.domain[var] for var in variables]
    
    for vals in Iterators.product(domains...)
        avals = Array(VT, length(A.variables))
        bvals = Array(VT, length(B.variables))

        for i = 1:vlen
            var = variables[i]
            val = vals[i]

            if contains(A.variables, var)
                ind = vectorIndex(A.variables, var)
                avals[ind] = val
            end
            if contains(B.variables, var)
                ind = vectorIndex(B.variables, var)
                bvals[ind] = val
            end
        end

        pot[vals...] = A[avals...] * B[bvals...]
    end
    
    return pot
end

# sumpot: sum a potential over variables, returning a new potential over
# the remaining variables
function sumpot{VT,DT}(pot::PotArray{VT,DT}, variables::Vector{VT})
    newVars = setdiff(pot.variables, variables)
    newDom = [var => pot.domain[var] for var in newVars]
    newPot = PotArray(newVars, newDom)

    newDoms = [newPot.domain[var] for var in newVars]
    oldDoms = [pot.domain[var] for var in variables]
    allVars = [newVars..., variables...]
    len = length(allVars)

    for newVals in Iterators.product(newDoms...)
        for oldVals in Iterators.product(oldDoms...)
            allVals = [newVals..., oldVals...] 
            vals = Array(VT, len)

            for i = 1:len
                var = allVars[i]
                val = allVals[i]

                ind = vectorIndex(pot.variables, var)
                vals[ind] = val
            end

            newPot[newVals...] += pot[vals...]
        end
    end
    
    return newPot
end
