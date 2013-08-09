function newpot=mrdivide(pot1,pot2)
%MRDIVIDE Divide logarray potential pot1 by pot2
% newpot=pot1/pot2

if ~isa(pot1,'brml.logarray')
    pot1=brml.logarray(pot1);
end

if ~isa(pot2,'brml.logarray')
    pot2=brml.logarray(pot2);
end

pot1.table=pot1.table;
pot2.table=pot2.table+eps; % in case any zeros
if length(pot2.table)==1; % scalar
    newpot=pot1; newpot.table=pot1.table-pot2.table;
else
    pot2.table=-pot2.table;
    newpot=pot1*pot2;
end