function newpot=plus(pot1,pot2)
%PLUS Sum two logarray potentials into a single brml.
% newpot = plus(pot1,pot2)
% eg: p=logarray(1,[0.1 0.9]); q=logarray(2,[0.3 0.7]); p+q

import brml.*

if ~isa(pot1,'brml.logarray')
    pot1=logarray(pot1);
end

if ~isa(pot2,'brml.logarray')
    pot2=logarray(pot2);
end

if isempty(pot1.table); newpot=pot2; return; end
if isempty(pot2.table); newpot=pot1; return; end

logprefactor=max([max(pot1.table(:)) max(pot2.table(:))]);
pot1.table=exp(pot1.table-logprefactor);
pot2.table=exp(pot2.table-logprefactor);

pots={pot1 pot2};
newpot=logarray;
[newpot.variables nstates]=potvariables(pots);
p=zeros_Array(nstates);

for j=1:2 % loop over all the brml.
    vars=pots{j}.variables;
    if ~isempty(pots{j}.table)
        pots{j}=orderpot(pots{j},sort(vars));
        [dummy thispotvarind]=ismember(pots{j}.variables,newpot.variables);
        s = size(pots{j}.table);
        if length(s)==2 && s(1)==1
            pots{j}.table=pots{j}.table(:); % for a 1 var brml. might be stored as row vector
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
newpot.table=log(p)+logprefactor;