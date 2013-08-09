function [maxstate maxvalpot mess]=maxNprodFG(pot,A,Nmax,varargin)
%MAXNPRODFG N-Max-Product algorithm on a Factor Graph (Returns the Nmax most probable States)
% [maxstate maxvalpot mess]=maxNprodFG(pot,A,Nmax,<mess>)
%
% pot is a set of potentials.
% A is a FG adjacency matrix with message numbers on the non-zero elements
% mess is the message initialisation. 
%
% returns most Nmax most probable joint states and their values, along with the messages.
% maxstate : each row is a state, with the first row the most likely state,
% followed by the next most likely etc.
import brml.*
pot=str2cell(pot);
variables=potvariables(pot);
V=length(variables); N=size(A,1);
fnodes=zeros(1,N); fnodes(V+1:end)=1:N-V; % factor nodes
vnodes=zeros(1,N); vnodes(1:V)=1:V; % variable nodes
nmess=full(max(max(A))); % number of messages

% The Nmax most probable messages are stored using an extra variable for each message:
mvars=V+1:V+nmess; % For each message this will index the n-most probable messages
mess=[]; if nargin==4; mess=varargin{1}; end
if isempty(mess) % message initialisation:
    clear mess
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

% now do the message passing:
for count=1:nmess
    [FGnodeA FGnodeB]=find(A==count);
    FGparents=setdiff(find(A(FGnodeA,:)),FGnodeB); % FGparent nodes of FGnodeA
    if ~isempty(FGparents)
        factor=fnodes(FGnodeA);
        tmpmess = multpots(mess(A(FGparents,FGnodeA)));
        if factor==0; % variable to factor message
            mess{count}=tmpmess;
        else % factor to variable message
            tmpmess = multpots([{tmpmess} pot(factor)]); % multiply all the messages
            [tmess maxst]= maxNpot(tmpmess,Nmax,FGnodeB,0); % max over all messages retaining only Nmax
            
            % now combine the messages into a single table:
            mess{count}=tmess;
            mess{count}.variables=[mess{count}.variables mvars(count)];
            switch class(mess{count})
                case 'brml.array'
                    mess{count}.table = reshape(vertcat(tmess.table{1:Nmax}),[numel(tmess.table{1}),Nmax]);
                otherwise
                    warning('combining of messages for this class not yet defined')
            end
        end
    end
end

% now find the maximum states:
for i=1:V
    [dum1 dum2 incoming]=find(A(:,i));
    tmpmess = multpots(mess(incoming)); 
    [maxvalpot b]=maxNpot(tmpmess,Nmax);
    for n=1:Nmax
        maxstate(n,i).state=b{n}(1); % the first component is the variable
    end
end
