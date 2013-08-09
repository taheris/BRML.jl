function [maxstate maxvalpot mess]=maxprodFG(pot,A,varargin)
% maxprodFG Max-Product algorithm on a Factor Graph
% [maxstate maxval mess]=maxprodFG(pot,A,<mess>)
%
% Inputs:
% pot : a set of potentials
% A : a Factor Graph adjacency matrix with message numbers on the non-zero elements
% mess: the message initialisation. If mess=[] the standard initialisation is used.
%
% Outputs:
% maxstate : maximum joint state
% maxval : associated (unnormalised) maximum value
% mess : Max Product messages
import brml.*
pot=str2cell(pot);
variables=potvariables(pot);
V=length(variables); N=size(A,1);
fnodes=zeros(1,N); fnodes(V+1:end)=1:N-V; % factor nodes
vnodes=zeros(1,N); vnodes(1:V)=1:V; % variable nodes
nmess=full(max(max(A))); % number of messages

if nargin==2;domessinit=1; else mess=varargin{1}; domessinit=0; end
if domessinit % message initialisation:
    for count=1:nmess
        mess{count}=const(1);
        [FGnodeA FGnodeB]=find(A==count);
        if fnodes(FGnodeA)>0 % factor to variable message:
            % if the factor is at the edge (simplical), need to set message to the factor potential
            if length(find(A(FGnodeA,:)))==1
                mess(count)=pot(fnodes(FGnodeA));
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
            mess{count} = maxpot(tmpmess,FGnodeB,0);
        end
    end
end

% now find the maximum states: variable nodes are first in the ordering, so
for i=1:V
    [dum1 dum2 incoming]=find(A(:,i));
    tmpmess = multpots(mess(incoming));
    [tmpmess maxstate(i)]=maxpot(tmpmess,i);
end
maxvalpot=maxpot(tmpmess);
