classdef (InferiorClasses = {?brml.const}) logconst <brml.potential
    % logconst Properties:
    % value: numeric scalar
    %
    % Inferior classes: brml.const
    
    methods
        function out=logconst(value)
            if nargin>0
                out.table=value;
                out.variables=[];
            end
        end
        
        %converters:
        
        function out=brml.const(obj)  % convert logconst-> const
            out=brml.const;
            out.table=exp(obj.table);
        end
        
        function out=brml.array(obj)  % convert logconst-> array
            out=brml.array;
            out.variables=obj.variables;
            out.table=exp(obj.table);
        end
        
        function out=brml.logarray(obj)  % convert logconst-> logarray
            out=brml.logarray;
            out.variables=obj.variables;
            out.table=obj.table;
        end
        
    end
end