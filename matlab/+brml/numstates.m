function nstates=numstates(pot)
%NUMSTATES Number of states of the variables in a potential
if length(pot)==1
    nstates=size(pot);
else
    for i=1:length(pot)
        nstates{i}=size(pot(i));
    end
end
