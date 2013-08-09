function newpot = sum(pot,vars)
% Marginalise a Gaussian in moment form and return the result in moment form.
%
% A moment form Gaussian is a distribution on a joint vector x:
%
% p(x)=exp(logprefactor)*exp(-0.5*(x-m)'*inv(Sigma)*(x-m))/sqrt(det(2*pi*Sigma))
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
%
% Then newpot=sum(pot,1) returns a Gaussian in variable 2
newpot=brml.GaussianMoment;
newtable=pot.table;
v=pot.variables;
newvars=setdiff(1:length(v),vars);
newinds=brml.getdimind(pot.table.dim,newvars);
newtable.mean=pot.table.mean(newinds);
newtable.covariance=pot.table.covariance(newinds,newinds);
newtable.dim=pot.table.dim(newvars);
newpot.variables=newvars;
newpot.table=newtable;