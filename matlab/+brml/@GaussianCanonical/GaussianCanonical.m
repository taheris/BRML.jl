classdef (InferiorClasses = {?brml.const,?brml.logconst}) GaussianCanonical< brml.potential
% GaussianCanonical Properties:
% exp(d)exp(-0.5 x'Ax + x'b)
% variables - vector of variables
% table.invcovariance - inverse covariance matrix A (precision) on the joint variables
% table.invmean - `inverse mean' vector b of the variables
% table.logprefactor - log prefactor d of the table
% table.dim - dimensions of the variables    
    methods
        
        function pot=GaussianCanonical(variables,table)
            
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
        
        % place converters here:
        function newpot=brml.GaussianMoment(pot) % convert GaussianCanonical-> GaussianMoment
            newpot=brml.GaussianMoment;
            newpot.variables=pot.variables;
            C=inv(pot.table.invcovariance);
            b=pot.table.invmean;
            mu = C*b;
            newpot.table.covariance=C;
            newpot.table.mean=mu;
            newpot.table.logprefactor=pot.table.logprefactor-0.5*b'*mu-0.5*brml.logdet(2*pi*pot.table.invcovariance);
            newpot.table.dim=pot.table.dim;
        end
    end
end