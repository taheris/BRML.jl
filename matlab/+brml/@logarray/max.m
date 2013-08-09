function [newpot maxstate]=max(pot,variables)
%MAX Maximise a multi-dimensional array over a set of dimenions
% [maxval maxstate]=max(x,variables)
% find the values and states that maximize the multidimensional array x
% over the dimensions in maxover
%
% See also maxNarray.m
newpot=pot;
st_variables =find(ismember(pot.variables,variables));
[newpot.table maxstate_all]=maxarray(pot.table,st_variables);
newpot.variables = setminus(pot.variables,variables); 
maxstate=maxstate_all(:,st_variables); % just return the states of variables maxed over