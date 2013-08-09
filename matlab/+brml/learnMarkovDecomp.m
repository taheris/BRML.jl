function newpot=learnMarkovDecomp(edist,root,varargin)
%LEARNMARKOVDECOMP learn the tables for a decomposable Markov net based on
%a set of local potentials
%
% pot=learnMarkovDecomp(edist,root,<opts>)
% edist is a reference (or empirical distribution)
% opts.plotprogress=1 : display progress
%
% edist{i}, i=1,... are local potentials whose global structure
% forms a decomposable graph. We can then form a joint global distribution
% by choosing a root node and renormalising
% see demoLearnMarkovDecomp.m
import brml.*
if nargin==2; opts.plotprogress=0; opts.doabsorption=0; else opts=varargin{1}; end
if opts.plotprogress; fprintf(1,'Computing the junction tree...\n'); end
[jtpot jtsep infostruct]=jtree(edist);
if opts.doabsorption;[jtpot jtsep]=absorption(jtpot,jtsep,infostruct); end
C=length(jtpot); % number of cliques
for c=1:C
    jtpot{c}=condpot(edist{whichpot(edist,jtpot{c}.variables,1)});
end
spTree=singleparenttree(infostruct.cliquetree,root);
[tree elimset schedule]=istree(spTree);
schedule=fliplr(flipud(schedule));
if opts.plotprogress; fprintf(1,'Updating the potential:\n'); end
newpot{root}=condpot(jtpot{root});
for c=1:size(schedule,1)
    if opts.plotprogress; fprintf(1,'Updating clique %d (of %d)\n',c,C); end
    pa=schedule(c,1); ch=schedule(c,2);
    vars1=setdiff(jtpot{ch}.variables,jtpot{pa}.variables);
    vars2=setdiff(jtpot{ch}.variables,vars1);
    newpot{ch}=condpot(jtpot{ch},vars1,vars2);
end