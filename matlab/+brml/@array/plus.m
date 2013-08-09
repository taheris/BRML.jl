function newpot = plus(pot1,pot2)
%PLUS Sum two array potentials into a single brml.
% newpot = plus(pot1,pot2)
% eg: p=array(1,[0.1 0.9]); q=array(2,[0.3 0.7]); p+q

import brml.*

if isempty(pot1.table); newpot=pot2; return; end
if isempty(pot2.table); newpot=pot1; return; end


if ~isa(pot1,'brml.array')
    pot1=array(pot1);
end

if ~isa(pot2,'brml.array')
    pot2=array(pot2);
end

% otherwise neither are consts:
newpot=array;
pots={pot1 pot2};
[newpot.variables nstates]=potvariables(pots);
p=zeros_Array(nstates);
for j=1:2 % loop over both potentials
    
    vars=pots{j}.variables;
    if ~isempty(pots{j}.table)
        pots{j}=orderpot(pots{j},sort(vars));
        [dummy thispotvarind]=ismember(pots{j}.variables,newpot.variables);
        s = size(pots{j}.table);
        if length(s)==2 && s(1)==1
            pots{j}.table=pots{j}.table(:); % for a 1 var potential might be stored as row vector
        end
        r = nstates; r(thispotvarind)=1;
        q = ones(1,length(nstates));
        q(thispotvarind)=size(pots{j});
        if length(q)>1
            t = reshape(pots{j}.table,q);
            t = reshape(repmat(t,r),nstates);
        else
            t=pots{j}.table(:);
        end
        p=p+t;
    end
end
newpot.table=p;