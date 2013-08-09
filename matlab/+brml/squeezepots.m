function [newpot newvars uniquevariables uniquenstates] = squeezepots(pots)
%SQUEEZEPOTS Eliminate redundant potentials (those contained wholly within
%another) by multiplying redundant potentials and renaming variables 1,2,3,....
% [newpot newvars uniquevariables uniquenstates] = squeezepots(pots)
import brml.*
uniquepot=uniquepots(pots);
[uniquevariables uniquenstates]=potvariables(uniquepot); 
newvars=1:length(uniquevariables);
newpot=changevar(uniquepot,uniquevariables,newvars);