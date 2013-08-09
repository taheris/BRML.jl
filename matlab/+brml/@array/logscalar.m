function x=logscalar(pot)
% x=logscalar(pot)
% if the table of the pot is a scalar, returns the log value of the potential
if isscalar(pot.table)
    x=log(pot.table);
else
    warning('table is not a scalar')
end