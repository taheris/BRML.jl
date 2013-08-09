function newpot = mtimes(pot1,pot2)
% newpot=mtimes(pot1,pot2)
% multiply two logconst potentials together pot1*pot2

if ~isa(pot1,'brml.logarray')
    pot1=brml.logarray(pot1);
end

if ~isa(pot2,'brml.logarray')
    pot2=brml.logarray(pot2);
end

newpot=brml.logconst(pot1.table+pot2.table);