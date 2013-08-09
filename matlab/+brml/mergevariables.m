function vars=mergevariables(pota,potb)

for p=1:length(pota)
    vars{p}.variables=union(pota{p}.variables, potb{p}.variables);
end