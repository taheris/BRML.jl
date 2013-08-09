function [newpot maxstate]=maxN(pot,variables,N)
% maxNarray Find the N highest values and states by maximising an array over a set of dimensions
% [maxval maxstate]=maxN(pot,variables,N)
% find the N highest values and corresponding states that maximize the multidimensional array x
% over the dimensions in maxover
% 
% Example:
% pot=array([1 2 3 4],randn(3,2,2,4));
% [maxval maxstate]=maxN(pot,[4 2],5)
% This means that we wish to maximise over the 2nd and 4th dimensions of x.  
% maxval and maxstate are then 5 dimensional cells with
% maxval{1} and maxstate{1} containing the highest values and corresponding
% states. Then maxval{2}, maxstate{2} are the next highest, etc.
% In this case, maxval{1} is a 6x1 dimensional vector since, after
% maximising over the 2nd and 4th dimensions of x, we are left with the
% 1st and 3rd dimensions still, which contain 3x2=6 states. The joint
% states of all variables corresponding to the maximal values are in
% maxstate{1}.
% See also maxarray.m maxNarray.m
import brml.*
newpot=array;
st_variables =find(ismember(pot.variables,variables));
newpot.variables = setminus(pot.variables,variables);

[newpot.table maxstate_all]=maxNarray(pot.table,st_variables,N);
for i=1:N
	maxstate{i}=maxstate_all{i}(:,st_variables); % just return the states of variables maxed over
end
