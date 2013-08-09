function [newpot maxstate] = maxNpot(pot,N,varargin)
%MAXNPOT Maximise a potential over variables, finding the N most likely states
% [newpot maxstate] = maxpotN(pot,N,invariables,<maxover>)
%
% Inputs:
% pot : a potential
% N : the number of states to be found
% invariables : the variables to optimise over
% By default we maximise over invariables.
% if <maxover>=1 then the potential is maxed over variables, otherwise the
% potential is maxed over everything except variables. For example, to find
% the maximum value and state over all variables, use [newpot maxstate] = maxpot(pot,[],0)
%
% Outputs:
% newpot : remaining potential after performing the maximisation
% maxstate : returns the states (of the variables maxed over)
maxover=1; % default setting
if nargin==2; invariables=[]; maxover=0;
else
    invariables=varargin{1};
end
if length(varargin)==2
    maxover=varargin{2};
end
if maxover
    variables=invariables;
else
    variables=setdiff(pot.variables,invariables);
end
[newpot maxstate]=maxN(pot,variables,N);
