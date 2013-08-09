function newpot = permute(pot,perm)
% permute the variables in an array potential
% example: p=array([1 2 3 4],rand(2,3,4,5)); q=permute(p,[4 2 1 3]);
newpot=pot;
if length(perm)>1
    newpot.variables(perm)=pot.variables;
    newpot.table=permute(pot.table,perm);
end