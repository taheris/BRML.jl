function newpot = mtimes(pot1,pot2)
% Multiply two Gaussians in Canonical form and return the result in Canonical form.
%
% A Canonical form Gaussian is a distribution on a joint vector x:
%
% p(x)=exp(logprefactor)*exp(-0.5*x'*M*x+x'*b)
%
% pot.variables: the variables that are contained in the joint vector x
% pot.table.b: `inverse' mean vector b
% pot.table.invcovariance: inverse covariance matrix M
% pot.table.logprefactor: log of any scalar prefactor 
% pot.table.dim : the dimensions of pot.variables
%
% For example:
% pot.variables=[1 2]; % names of the variables contained in this Gaussian brml.
% pot.table.dim=[3 2]; % variable 1 is 3 dimensional and occupies indices 1:3. 
%                        Variable 2 is 2 dimensional and occupies indices 4:5
% pot.table.invmean=randn(5,1); 
% pot.table.invcovariance=eye(5);
% pot.table.logprefactor=0;

newpot=brml.GaussianCanonical;

if isa(pot1,'brml.const')
    newpot=pot2;
    newpot.table.logprefactor=newpot.table.logprefactor+log(pot1.table);
    return
end

if isa(pot2,'brml.const')
    newpot=pot1;
    newpot.table.logprefactor=newpot.table.logprefactor+log(pot2.table);
    return
end

if ~isa(pot1,'brml.GaussianCanonical')
    pot1=brml.GaussianCanonical(pot1);
end

if ~isa(pot2,'brml.GaussianCanonical')
    pot2=brml.GaussianCanonical(pot2);
end


v1=pot1.variables;
v2=pot2.variables;
[v ns]=brml.potvariables([pot1 pot2]);
[dum vind1]=ismember(v1,v);
[dum vind2]=ismember(v2,v);
newdim(vind1)=pot1.table.dim;
ind1=brml.getdimind(ns,vind1);

newdim(vind2)=pot2.table.dim;
ind2=brml.getdimind(ns,vind2);

n=sum(newdim);
    
invcov1=pot1.table.invcovariance;
invcov2=pot2.table.invcovariance;
invm1=pot1.table.invmean;
invm2=pot2.table.invmean;
invmm1=zeros(n,1); invmm2=zeros(n,1); invcc1=zeros(n,n); invcc2=zeros(n,n);
invmm1(ind1)=invm1; invmm2(ind2)=invm2;
invcc1(ind1,ind1)=invcov1;invcc2(ind2,ind2)=invcov2;

invC=invcc1+invcc2;
invm=invmm2+invmm1;

newpot.variables=v;

newpot.table.invmean=invm;
newpot.table.invcovariance=invC;
newpot.table.logprefactor=pot1.table.logprefactor+pot2.table.logprefactor;

newpot.table.dim=newdim;