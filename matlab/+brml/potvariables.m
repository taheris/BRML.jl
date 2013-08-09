function [variables nstates con convec]=potvariables(inpot)
%POTVARIABLES Returns information about all variables in a set of potentials
% [variables nstates con convec]=potvariables(pot)
%
% return the variables and their number of states
% If there is a dimension mismatch in the tables then return con=0
% convec(i)=0 reports that variable i has conflicting dimension

import brml.*;

pot=str2cell(inpot);

if isempty(pot);return;end

v=cell2mat(cellfun(@cellvariables,pot,'UniformOutput',false));

variables=[];nstates=[]; con=1;convec=[];

if ~isempty(v)
    [a b]=sort(v); i=[b(diff(a)>0) b(end)];variables=v(i);
    N=max(variables);
    convec=ones(1,N);nstates=-ones(1,N);
    for p=1:length(pot)
        if ~isempty(pot{p}.variables)
            nstates(1,pot{p}.variables) = size(pot{p});
        end
        if p>1
            convec(nstates(oldnstates>-1)~=oldnstates(oldnstates>-1))=0;
        end
        oldnstates=nstates;
    end
    con = all(convec); if con==0; warning(['inconsistent dimensions for variables ',num2str(variables(~convec))],'brml'); end
else
    variables=[]; nstates=[];
end
nstates=nstates(nstates>0);