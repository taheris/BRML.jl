function [jtprob jtutil infostruct]=jtreeID(prob,util,partialorder)
%JTREEID Setup a Junction Tree based on an Influence Diagram
%[jtprob jtutil infostruct]=jtreeID(prob,util,partialorder)
% Setup a Junction Tree from an Influence Diagram
% For the Decision Potentials, with prob(i) and util(j) being their components,
% and a partial ordering,  return a set of Junction Tree Decision Potentials (no separator) with initialised
% Junction Tree potentials
%
% Inputs:
% prob : probability potentials in an Influence Diagram
% util : the utilities for the ID
% partialorder :  partialorder{1}<partialorder{2}<partialorder{3}<...
%
% Outputs:
% jtprob : clique potentials
% jtutil : JT utility potenials
% infostruct contains information about the structure of the Junction Tree (not usually required)
%
% The JT potentials are ordered so that jtprob(end) and jtutil(end) contain
% the root of the tree. This means that jtutil(end) contains the utilities
% having maxed and summed over all other variables.
import brml.*
prob=str2cell(prob); util=str2cell(util);
pot=[prob util];
[variables nstates]=potvariables(pot);
% -------------------------------
% Find the adjacency matrix from all potentials:
N=length(variables); A = eye(N,N);
for i=1:length(pot)
    family=pot{i}.variables; A(family,family)=1; % put all family in a cliquo (moralises if a BN)
end
% -------------------------------
% triangulation
for i=1:length(partialorder);
    if isfield(partialorder{i},'sum')
        tmpporder{i}=partialorder{i}.sum;
    end
    if isfield(partialorder{i},'max')
        tmpporder{i}=partialorder{i}.max;
    end
end
[Atri cliquevariables elimseq] = triangulatePorder(A,tmpporder);
% Connection Structure of the cliques
C=length(cliquevariables); Atree=sparse(C,C);
% make a dummy potential so we can call whichpot
for c=1:C
    cl{c}.variables=cliquevariables{c};
end

for c=1:C-1
    cliques = whichpot(cl,setdiff(cliquevariables{c},elimseq(c)));
    Atree(c,min(cliques(cliques>c)))=1; % link to lowest available clique
end

% -------------------------------
% Assign all clique potentials to 1 initially (and utilities to zero)
for c=1:C
    jtprob{c}=const(1);
    jtutil{c}=const(0);    
end

for p=1:length(prob)
    % find the clique for this potential and multiply it to the existing potential.
    for c=1:C
        if all(ismember(prob{p}.variables,cl{c}.variables))
            jtprob{c}=multpots([jtprob(c) prob(p)]);
            break
        end
    end
end
for p=1:length(util)
    % find the clique for this utility and sum it to the existing utility
    for c=1:C
        if all(ismember(util{p}.variables,cl{c}.variables))
            jtutil{c}=sumpots([jtutil(c) util(p)]);
            break
        end
    end
end
infostruct.cliquetree=Atree; % connectivity structure of JT cliques
infostruct.clique=cl;
infostruct.cliquevariables=cliquevariables;