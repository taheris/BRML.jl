function newpot=logpot(pot)
%LOGPOT logarithm of the potential
import brml.*
pot=str2cell(pot);
if length(pot)>1
    for p=1:length(pot)
        newpot{p}=log(pot{p});
    end
else
    newpot=log(pot{1});
end