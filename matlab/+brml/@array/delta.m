function newpot = delta(pot,evvariables,evidstates,nstates_evvariables)
%DELTA A delta function potential for an array
% newpot = delta(pot,evvariables,evidstates,nstates_evvariables)
% Inputs:
% evvariables : variables that are evidential
% evidstates  : the corresponding states
% nstates_evvariables): number of states of the evidential variables
% Output :
% newpot : a delta function brml.over evvariables, with mass only in the evidential states
import brml.*;
newpot=array;
newpot.variables=evvariables;
tmp=zeros(prod(nstates_evvariables),1);
tmp(subv2ind(nstates_evvariables,evidstates(:)'))=1;
if isempty(evvariables)
    newpot.table=1;
else
    newpot.table=tmp();
end
if length(evvariables)>1; newpot.table=reshape(newpot.table,nstates_evvariables); end