classdef (InferiorClasses = {?brml.array,?brml.const,?brml.logconst}) ...
        logarray < brml.potential
% logarray Properties:
% variables
% table
%
% Inferior classes: brml.array, brml.const, brml.logconst
% type help logarray.logarray for constructor help
    methods
        function arr=logarray(variables,table)
            % logarray(<variables>,<table>)
            % eg pot=logarray([1 2],rand(2,2))
            % or pot=logarray; pot.variables=[1 2]; pot.table=rand(2,2);
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
                    
                    %if length(variables)~=length(size(table))
                    %    error('number of declared variables is not equal to the number of variables in the table')
                    %end
                end
            end
        end
        
    end   
    
end