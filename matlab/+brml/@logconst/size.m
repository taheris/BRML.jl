function nstates = size(obj)
% takes value 1 for logconst potentials
s=size(obj.table);
if length(s)==2 && sum(s==1)==1
    nstates=max(s);
elseif  prod(s)<=1
    nstates=prod(s);
else
    nstates=s;
end