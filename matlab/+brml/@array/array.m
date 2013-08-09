classdef (InferiorClasses = {?brml.const,?brml.logconst}) array < brml.potential
% array Properties:
% variables
% table
%
% Inferior classes: brml.const, brml.logconst
% type help array.array for constructor help    
    methods
        
        function arr=array(variables,table)
            % array(<variables>,<table>)
            % eg pot=array([1 2],rand(2,2))
            % or pot=array; pot.variables=[1 2]; pot.table=rand(2,2);
            if nargin>0
                if ~isnumeric(variables)
                    error('variables must be a numerical vector')
                else
                    arr.variables=variables;
                end
                
                if nargin>1
                    if ~isnumeric(table)
                        error('table must be a numerical array')
                    else
                        arr.table=table;
                    end
                    
                    if length(variables)~=length(brml.mysize(table))
                        error('number of declared variables is not equal to the number of variables in the table')
                    end
                end
            end
        end
        
        % place converters here:
        function out=brml.logarray(obj) % convert array -> logarray
            out=brml.logarray;
            out.variables=obj.variables;
            out.table=log(obj.table);
        end
    end
end