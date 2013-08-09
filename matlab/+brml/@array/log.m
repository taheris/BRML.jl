function newpot=log(pot)
%LOG logarithm of the potential
%  newpot=log(pot)
import brml.*
if length(pot)>1
    for p=1:length(pot)
        newpot(p)=pot(p);
        newpot(p).table=log(replace(pot(p).table,0,10e-10));
    end
else
    newpot=pot;
    newpot.table=log(replace(pot.table,0,10e-10));
end