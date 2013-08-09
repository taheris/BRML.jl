function x=logscalar(pot)
% x=logscalar(pot)
% Returns the log value of the const potential
if isscalar(pot.table)
    x=log(pot.table);
else
    warning('table is not a scalar')
end