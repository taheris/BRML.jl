function [jtprob jtutil utilroot]=absorptionID(jtprob,jtutil,infostruct,partialorder)
%ABSORPTIONID Perform full round of absorption on an Influence Diagram
% [jtprob jtutil utilroot]=absorptionID(jtprob,jtutil,infostruct,partialorder)
% Absorption on an Junction Tree of an Influence Diagram
% see also jtreeID.m
import brml.*
schedule=1:length(jtprob)-1;
Atree=infostruct.cliquetree; % clique tree

for s=schedule
    % absorb pot(a)-->pot(b)
    pota = s;
    potb = find(Atree(s,:));
    
    sepvars=intersect(infostruct.cliquevariables{pota},infostruct.cliquevariables{potb});
    maxsumvars=setdiff(infostruct.cliquevariables{pota},sepvars);
    
    % probability update:    
    sepprob = maxsumpot(jtprob{pota},maxsumvars,partialorder);
    jtprob{potb}=multpots([jtprob(potb) {sepprob}]);
    
    % utility update:    
    seputil = maxsumpot(multpots([jtprob(pota) jtutil(pota)]),maxsumvars,partialorder);      
    jtutil{potb}=sumpots([jtutil(potb) {divpots(seputil,sepprob)}]); 
end
[~, utilroot]=sumpotID(jtprob(end),jtutil(end),[],[],partialorder,0); utilroot=utilroot.table;
