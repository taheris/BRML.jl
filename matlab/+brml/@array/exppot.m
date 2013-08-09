function newpot=exppot(pot,varargin)
%EXPPOT exponential of a potential
% newpot=exppot(pot,<norm>)
% If norm=1, each potential is renormalised so that it has largest element 1
import brml.*
donorm=false;
pot=str2cell(pot);
if nargin==2
    donorm=varargin{1};
end
if donorm
    for p=1:length(pot)
        newpot{p}=pot{p};
        newpot{p}.table=exp(pot{p}.table-max(pot{p}.table(:)));
    end
else
    for p=1:length(pot)
        newpot{p}=pot{p};
        newpot{p}.table=exp(pot{p}.table);
    end
end