function [marg mess normconstpot]=sumprodFG(pot,A,varargin)
%SUMPRODFG Sum-Product algorithm on a Factor Graph represented by A
% [marg mess normconstpot]=sumprodFG(pot,A,<mess>)
%
% Inputs:
% pot : set of potentials
% A : matrix representing the Factor Graph (see FactorGraph.m)
% mess are the initial messages. If mess=[], the standard initialisation is used.
%
%
% Outputs:
% marg : the single variable marginals (unnormalised)
% mess: the FG messages
% normconstpot = sum_{all variables} prod_{all factors} pot{}
%
% see demoSumprod.m, FactorConnectingVariable.m
import brml.*
variables=potvariables(pot);
V=length(variables); N=size(A,1);
fnodes=zeros(1,N); fnodes(V+1:end)=1:N-V; % factor nodes
vnodes=zeros(1,N); vnodes(1:V)=1:V; % variable nodes
nmess=full(max(max(A))); % number of messages
if nargin==2; initmess=[]; else initmess=varargin{1};end
if ~isempty(initmess); mess=initmess; end
if isempty(initmess) % message initialisation
    for count=1:nmess
 
        mess{count}=const(1);
        [FGnodeA FGnodeB]=find(A==count);
        if fnodes(FGnodeA)>0 % factor to variable message:
            % if the factor is at the edge (simplical), need to set message to the factor potentials
            if length(find(A(FGnodeA,:)))==1
                mess(count)=pot(fnodes(FGnodeA));     % nb: need mess() here since pot() returns a cell        
            end
        end
    end
end
 
% Do the message passing:
for count=1:length(mess)
    [FGnodeA FGnodeB]=find(A==count);
    FGparents=setdiff(find(A(FGnodeA,:)),FGnodeB); % FG parent nodes of FGnodeA
    if ~isempty(FGparents)
        tmpmess = multpots(mess(A(FGparents,FGnodeA))); % product of incoming messages
        
        factor=fnodes(FGnodeA);
        if ~factor % variable to factor message:
            mess{count}=tmpmess;
        else % factor to variable message:
            tmpmess = multpots([{tmpmess} pot(factor)]);
            mess{count} = sumpot(tmpmess,FGnodeB,0);         
        end
       
    end
end
% Get all the marginals: variable nodes are first in the ordering, so
for i=1:V
    [dum1 dum2 incoming]=find(A(:,i));
    tmpmess = multpots(mess(incoming));
    marg{i}=tmpmess;
end
normconstpot=sumpot(multpots(mess(mess2var(1,A))));