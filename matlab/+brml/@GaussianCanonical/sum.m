function newpot = sum(pot,vars)
% Marginalise a Gaussian in Canonical form and return the result in Canonical form.
%
% vars are the variables that are marginalised over.
%
% A Canonical form Gaussian is a distirbution on a joint vector x:
%
% p(x)=exp(logprefactor)*exp(-0.5*x'*M*x+x'*b)
%
%
% pot.variables: the variables that are contained in the joint vector x
% pot.type='GaussianCanonical'
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
%
% Then newpot=sumpot_GaussianCanonical(pot,2) would return a Canonical
% Gaussian in variable 1 alone.

newpot=brml.GaussianCanonical;
newtable=pot.table;
v=pot.variables;
newvars=setdiff(v,vars);
newvarnumb=find(~ismember(v,vars));
newinds=brml.getdimind(pot.table.dim,newvarnumb);

[a oldvarnumb]=find(ismember(v,vars));
oldinds=brml.getdimind(pot.table.dim,oldvarnumb);

if ~isempty(newvars)
    newtable.invcovariance=pot.table.invcovariance(newinds,newinds)-...
        pot.table.invcovariance(newinds,oldinds)*inv(pot.table.invcovariance(oldinds,oldinds))*pot.table.invcovariance(oldinds,newinds);
    newtable.invmean=pot.table.invmean(newinds)-...
        pot.table.invcovariance(newinds,oldinds)*inv(pot.table.invcovariance(oldinds,oldinds))*pot.table.invmean(oldinds);
else
    newtable.invcovariance=[]; newtable.invmean=[];
end
newtable.logprefactor=pot.table.logprefactor+....
    0.5*pot.table.invmean(oldinds)'*inv(pot.table.invcovariance(oldinds,oldinds))*pot.table.invmean(oldinds)+...
    0.5*brml.logdet(2*pi*pot.table.invcovariance(oldinds,oldinds));
[a inds]=ismember(newvars,v);
newtable.dim=pot.table.dim(inds);
newpot.variables=newvars;
newpot.table=newtable;
