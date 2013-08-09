classdef (InferiorClasses = {?brml.const,?brml.logconst}) GaussianMoment < brml.potential
% GaussianMoment Properties:
% variables - vector of variables
% table.covariance - covariance matrix on the variables
% table.mean - mean vector of the variables
% table.logprefactor - log prefactor of the table
% table.dim - dimensions of the variables

    methods
        
        function pot=GaussianMoment(variables,table)
            
            if nargin>0
                if ~isnumeric(variables)
                    error('variables must be a numerical vector')
                else
                    pot.variables=variables;
                end
                
                if nargin>1
                    if ~isstruct(table)
                        error('table must be a structure')
                    else
                        pot.table=table;
                    end
                end              
            end
        end
        
        %          place converters here:
        function newpot=brml.GaussianCanonical(pot) % convert GaussianMoment-> GaussianCanonical
            newpot=brml.GaussianCanonical;
            newpot.variables=pot.variables;
            C=pot.table.covariance;
            mu=pot.table.mean;
            newpot.table.invcovariance=inv(C);
            newpot.table.invmean=newpot.table.invcovariance*mu;
            newpot.table.logprefactor=pot.table.logprefactor-0.5*mu'*newpot.table.invmean-0.5*brml.logdet(2*pi*C);
            newpot.table.dim=pot.table.dim;
        end
    end
end