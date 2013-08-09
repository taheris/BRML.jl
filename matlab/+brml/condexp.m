function pnew=condexp(logp)
%CONDEXP  Compute p\propto exp(logp);
pmax=max(logp,[],1); P =size(logp,1);
pnew = brml.condp(exp(logp-repmat(pmax,P,1)));