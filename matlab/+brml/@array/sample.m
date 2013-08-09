function x=sample(pot,nsamples)
%SAMPLE Draw exact samples from an array potential
% x=sample(pot,nsamples)
import brml.*
pot=str2cell(pot);
[variables nstates]=potvariables(pot);
if isempty(nstates); x=[]; return; end
tab = pot{1}.table(:);
x = zeros(length(variables),nsamples);
for samp=1:nsamples
    randindex = randgen(tab);
    x(:,samp) = ind2subv(nstates,randindex);
end