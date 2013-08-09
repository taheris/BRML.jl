function kl = KLdiv(q,p)
%KLdiv Compute the Kullback-Leibler divergence between distributions q and p 
%
%  kl = KLdiv(q,p)
import brml.*
entropic = table(sumpot(multpots([q logpot(q)])));
energic = table(sumpot(multpots([q logpot(p)])));
kl = entropic-energic;