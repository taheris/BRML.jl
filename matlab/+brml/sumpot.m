function newpot = sumpot(pot,varargin)
%SUMPOT Sum potential over variables
% newpot = sumpot(pot,<variables>,<sumover>)
%
% if called with the additional argument: sumpot(pot,variables,sumover)
% if sumover=1 then potential is summed over variables, otherwise the
% potential is summed over everything except variables
% if called as sumpot(pot), it is assumed that all variables of pot are to be summed over
sumover=1; % default setting
pot=brml.str2cell(pot);
if nargin==1; invariables=[]; sumover=0;
else
    invariables=varargin{1};
end
if length(varargin)==2
    sumover=varargin{2};
end
if length(pot)>1
for p=1:length(pot)
    if sumover
        variables=invariables;  % variables that will be summed over
    else
        variables=setdiff(pot{p}.variables,invariables); % variables that will be summed over
    end
    newpot{p}=sum(pot{p},variables);
end
else
    if sumover
        variables=invariables;  % variables that will be summed over
    else
        variables=setdiff(pot{1}.variables,invariables); % variables that will be summed over
    end
    newpot=sum(pot{1},variables);
end