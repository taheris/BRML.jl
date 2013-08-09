function newpot = mtimes(pot1,pot2)
% newpot=mtimes(pot1,pot2)
% multiply two const potentials together pot1*pot2

if ~isa(pot1,'brml.const')
    pot1=brml.const(pot1);
end

if ~isa(pot2,'brml.const')
    pot2=brml.const(pot2);
end


newpot=brml.const(pot1.table*pot2.table);