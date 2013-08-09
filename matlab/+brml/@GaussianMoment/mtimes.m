function newpot = mtimes(pot1,pot2)
% Multiply two Gaussians in moment form and return the result in moment form.
%
% A moment form Gaussian is a distirbution on a joint vector x:
%
% p(x)=exp(logprefactor)*exp(-0.5*(x-m)'*inv(Sigma)*(x-m))/sqrt(det(2*pi*Sigma))
%
%
% pot.variables: the variables that are contained in the joint vector x
% pot.table.mean: mean vector m
% pot.table.covariance: covariance matrix Sigma
% pot.table.logprefactor: log of any scalar prefactor 
% pot.table.dim : the dimensions of pot.variables
%
% For example:
% pot.variables=[1 2]; % names of the variables contained in this Gaussian brml.
% pot.table.dim=[3 2]; % variable 1 is 3 dimensional and occupies indices 1:3. 
%                        Variable 2 is 2 dimensional and occupies indices 4:5
% pot.table.mean=randn(5,1); 
% pot.table.covariance=eye(5);
% pot.table.logprefactor=0;

import brml.*

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

if isempty(pot1.variables)
    newpot=pot2;
    newpot.table.logprefactor=newpot.table.logprefactor+pot1.table.logprefactor;
    return
end

if isempty(pot2.variables)
    newpot=pot1;
    newpot.table.logprefactor=newpot.table.logprefactor+pot2.table.logprefactor;
    return
end


if isa(pot2,'brml.const')
    newpot=pot1;
    newpot.table.logprefactor=newpot.table.logprefactor+log(pot2.table);
    return
end


if ~isa(pot1,'brml.GaussianMoment')
    pot1=GaussianMoment(pot1);
end

if ~isa(pot2,'brml.GaussianMoment')
    pot2=GaussianMoment(pot2);
end

newpot=GaussianMoment;

v1=pot1.variables;
v2=pot2.variables;
[v ns]=potvariables([pot1 pot2]);
[dum vind1]=ismember(v1,v);
[dum vind2]=ismember(v2,v);
newdim(vind1)=pot1.table.dim;
ind1=getdimind(ns,vind1);

newdim(vind2)=pot2.table.dim;
ind2=getdimind(ns,vind2);

n=sum(newdim);

m1=pot1.table.mean;
m2=pot2.table.mean;
cov1=pot1.table.covariance;
cov2=pot2.table.covariance;
mm1=zeros(n,1); mm2=zeros(n,1); invcc1=zeros(n,n); invcc2=zeros(n,n);
mm1(ind1)=m1; mm2(ind2)=m2;
invcc1(ind1,ind1)=inv(cov1);invcc2(ind2,ind2)=inv(cov2);

A=invcc1+invcc2;
b=invcc1*mm1+invcc2*mm2;
C=inv(A);
m=A\b;

logc=0.5*b'*m-0.5*(mm1'*invcc1*mm1+mm2'*invcc2*mm2)-0.5*logdet(2*pi*cov1)-0.5*logdet(2*pi*cov2)-0.5*logdet(A/(2*pi));
newpot.table.mean=m;
newpot.table.covariance=C;
newpot.table.logprefactor=logc+pot1.table.logprefactor+pot2.table.logprefactor;
newpot.variables=v;
newpot.table.dim=newdim;