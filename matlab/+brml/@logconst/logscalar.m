function x=logscalar(pot)
% x=logscalar(pot)
% Returns the value of the logconst potential
if isscalar(pot.table)
    x=pot.table;
else
    warning('table is not a scalar')
end