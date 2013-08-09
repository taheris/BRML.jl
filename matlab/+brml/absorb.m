function [newpots,newpotb] = absorb(pota,pots,potb,sepvars,varargin)
%ABSORB Update potentials in absorption message passing on a Junction Tree
% [newpots,newpotb] = absorb(pota,pots,potb,sepvars,<operation>)
%
% Absorption: update separator pots and potb, after absorbing from pota:  pota --> pots --> potb
% <operation> either 'max' or 'sum'.
% By default sum-absorption is carried out.
%
% Empty tables are ignored.
import brml.*
if isempty(varargin)
    operation='sum';
else
    operation=varargin{1};
end
switch operation
    case 'sum'
        newpots = sumpot(pota,setdiff(pota.variables,sepvars));
    case 'max'
        if ~isempty(pota.table)
            newpots = maxpot(pota,setdiff(pota.variables,sepvars));
        else
            newpots=pots;
        end
end
if ~isempty(pots.table)
    newpotb = divpots(multpots([{potb} {newpots}]),pots);
else
    newpotb = multpots([{potb} {newpots}]);
end