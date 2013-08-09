function newpot = condpot(pot,varargin)
%CONDPOT Return a potential conditioned on another variable
% newpot = condpot(pot,x,y)
% condition the potential to return potential with distribution p(x|y), summing over
% remaining variables. If y is empty (or missing), return the marginal p(x)
% If both x and y are missing, just return the normalised table
import brml.*
pot=str2cell(pot);
if length(varargin)>0
    x=varargin{1};
    if length(varargin)==1
        y=[];
    else
        y=varargin{2};
    end
    for p=1:length(pot)
        if isempty(y)
            newpot{p}=sum(pot{p},setdiff(pot{p}.variables,x));
            newpot{p}=divpots(newpot{p},brml.sumpot(newpot{p}));
        else
            pxy=sum(pot{p},setdiff(pot{p}.variables,[x(:)' y(:)']));
            py =sum(pxy,x);
            newpot{p}=brml.divpots(pxy,py); % p(x|y) = p(x,y)/p(y)           
        end
    end
else
    newpot=pot;
    for p=1:length(pot)
        newpot{p}=brml.divpots(newpot{p},sumpot(newpot{p}));
    end
end
if length(pot)==1
    newpot=newpot{1};
end
