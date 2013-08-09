function [jtpot jtsep logZ]=absorption(jtpot,jtsep, infostruct,varargin)
%ABSORPTION Perform full round of absorption on a Junction Tree
% [jtpot jtsep logZ]=absorption(jtpot,jtsep, infostruct,<operation>)
%
% Perform (sum)absorption for a JT specified with potential jtpot and
% separator potential jtsep. The distribution marginals are contained in
% the returned jtpot. The global log normalisation is returned in logZ.
%
% infostruct is a structure with information about the Junction Tree:
% infostruct.cliquetree : connectivity structure of Junction Tree cliques
% infostruct.sepind : the indices of separators: sepind(i,j)=separator index
% infostruct.EliminationSchedule is a list of clique to clique
% eliminations. The root clique is contained in the last row.
% infostruct.ForwardOnly is optional. If this is set to 1 only the schedule contained
% in infostruct.EliminationSchedule is carried out. Otherwise both a
% forward and backward schedule is carried out.
% <operation> can be 'sum' or 'max'. By default sum-absorption is carried out. 
%
% see also jtree.m, absorb.m, jtassignpot.m
import brml.*
sepind=infostruct.sepind; % the indices of separators sepind(i,j)=separator index
% Perform absorption:
schedule=infostruct.EliminationSchedule;
ForwardOnly=0;
if isfield(infostruct,'ForwardOnly')
    ForwardOnly=infostruct.ForwardOnly;
end
if ~ForwardOnly
    reverseschedule=flipud(fliplr(schedule));
    schedule=vertcat(schedule,reverseschedule); % full round over all separators in both directions
end
if isempty(varargin)
    operation='sum';
else
    operation=varargin{1};
end
for count=1:length(schedule)
    [elim neigh]=assign(schedule(count,:));
    if elim~=neigh   
    [jtsep{sepind(elim,neigh)} jtpot{neigh}]=absorb(jtpot{elim},jtsep{sepind(elim,neigh)},jtpot{neigh},...
        infostruct.separator{sepind(elim,neigh)},operation);    
    end
    
end
logZ=0; % logZ is the sum of all numerator normalisations minus all separator normalisations
for c=1:length(jtpot)
    logZ=logZ+logscalar(sumpot(jtpot{c}));
end
for c=1:length(jtsep)
    logZ=logZ-logscalar(sumpot(jtsep{c}));
end