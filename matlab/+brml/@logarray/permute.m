function newpot = permute(pot,perm)
% permute the variabes in a logarray
newpot=pot;
if length(perm)>1
newpot.variables(perm)=pot.variables;
newpot.table=permute(pot.table,perm);
end