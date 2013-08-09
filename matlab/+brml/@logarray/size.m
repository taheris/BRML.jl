function nstates = size(obj)
% nstates=size(pot)
% number of states of the logarray potential
s=size(obj.table);
if length(s)==2 && sum(s==1)==1
    nstates=max(s);
elseif  prod(s)<=1
    nstates=prod(s);
else
    nstates=s;
end