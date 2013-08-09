function newpot= setpot(pot,evvariables,evidstates)
%SETPOT sets brml.variables to specified states
% newpot = setpot(pot,variables,evidstates)
%
% set variables in potential to evidential states in evidstates
% Note that the new potential does not contain the evidential variables
if length(pot)>1
    for p=1:length(pot)
        newpot{p}=setpot(pot{p},evvariables,evidstates);
    end
else
    newpot=setpot(pot,evvariables,evidstates);
end