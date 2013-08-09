function newpot = reshape(pot,group)
%RESHAPR an array potential based on grouping variables together
% [newpot group] = reshape(pot,group)
%
% pot is a potential
% If pot is a set of potentials, they are multiplied together
% group(i).variables contains the variables in group i
% See also ungrouppot.m, groupstate.m, demogrouppot.m
import brml.*

% find which group variables are required:
pot=multpots(pot);
gpvar=[];
[variables nstates]=potvariables(pot);
for i=1:length(variables)
    for j=1:length(group)
        if ismember(variables(i),group(j).variables)
            gpvar=union(gpvar,j);
        end
    end
end
newpot=pot;
newpot.variables=gpvar;
newvar=[]; gnstates=[];
for i=gpvar;
    for j=1:length(group(i).variables);
        if ismember(group(i).variables(j),variables)
            group(i).nstates(j)=nstates(variables==group(i).variables(j));
        end
    end
    gnstates=[gnstates prod(group(i).nstates)];
    newvar=[newvar group(i).variables];
end
changepot=orderpot(pot,newvar);
newpot=reshape(pot,group)

if length(gnstates)>1
    newpot.table=reshape(changepot.table,gnstates);
else
    newpot.table=changepot.table(:);
end

