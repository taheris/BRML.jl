function demoSumprodGaussCanon
%DEMOSUMPRODGAUSSCANON Sum-Product algorithm test on canonical Gaussians

import brml.*
% Variable order is arbitary
variables=1:3; [a b c]=assign(variables);
globaldim=[2 3 1]; % number of dimensions of each variable

pot{1}=GaussianCanonical;
pot{1}.variables=[b a]; tmp=randn(sum(globaldim(pot{1}.variables)));
pot{1}.table.invmean=randn(sum(globaldim(pot{1}.variables)),1);
pot{1}.table.invcovariance=tmp*tmp'; pot{1}.table.logprefactor=0;
pot{1}.table.dim=globaldim(pot{1}.variables);

pot{2}=GaussianCanonical;
pot{2}.variables=[b c]; 
tmp=randn(sum(globaldim(pot{2}.variables)));
pot{2}.table.invmean=randn(sum(globaldim(pot{2}.variables)),1);
pot{2}.table.invcovariance=tmp*tmp'; pot{2}.table.logprefactor=0;
pot{2}.table.dim=globaldim(pot{2}.variables);

A = FactorGraph(pot); figure; drawFG(A);
margCanonical=sumprodFG(pot,A); % do the messages passing on the canonical form
marg=convertpot(margCanonical,'GaussianMoment'); % convert result to moment form for ease of display

% as a check, perform the marginalisation without message passing:
jointpotCanonical = multpots(pot); % canonical form joint
jointpot = convertpot(jointpotCanonical,'GaussianMoment'); % convert to moment form for ease of display

disp('Message passing on Gaussians defined using the canonical representation.')
disp('Marginal distribution of each variable')
for i=1:length(variables)
    fprintf(1,'\nvariable %d:\n',i);
    margpot{i}= sumpot(jointpot,i,0);  
    disp(['mean (factor graph method): ',num2str(marg{i}.table.mean')])
    disp(['mean (raw integral method): ',num2str(margpot{i}.table.mean')])
    disp(['covariance(factor graph method): ',num2str(marg{i}.table.covariance(:)')])
    disp(['covariance(raw integral method): ',num2str(margpot{i}.table.covariance(:)')])
end