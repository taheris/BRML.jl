function [newpot maxstate] = maxpot(pot,varargin)
%MAXPOT Maximise a potential over variables
% [newpot maxstate] = maxpot(pot,invariables,<maxover>)
%
% Inputs:
% pot : a potential
% invariables : the variables to optimise over
% By default we maximise over invariables.
% if <maxover>=1 the potential is maxed over variables, otherwise the
% potential is maxed over everything except variables. For example, to find
% the maximum value and state over all variables, use [newpot maxstate] = maxpot(pot,[],0)
%
% Outputs:
% newpot : remaining potential after performing the maximisation
% maxstate : returns the states (of the variables maxed over)
maxover=1; % default setting
pot=brml.str2cell(pot);
if nargin==1; invariables=[]; maxover=0;
else
    invariables=varargin{1};
end
if length(varargin)==2
    maxover=varargin{2};
end
if length(pot)>1
for p=1:length(pot)
    if maxover
        variables=invariables;  % variables that will be maxed over
    else
        variables=setdiff(pot{p}.variables,invariables); % variables that will be maxed over
    end
    [newpot{p} maxstate{p}]=max(pot{p},variables);
end
else
    if maxover
        variables=invariables;  % variables that will be maxed over
    else
        variables=setdiff(pot{1}.variables,invariables); % variables that will be maxed over
    end
    [newpot maxstate]=max(pot{1},variables);
end