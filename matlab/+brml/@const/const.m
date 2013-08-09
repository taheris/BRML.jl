classdef const < brml.potential
% const Properties:
% value: numeric scalar
    methods
        function out=const(value)
            % pot=const(<value>)
            % value is a numeric scalar
            if nargin>0
                out.table=value;
                out.variables=[];
            end
        end
        
        %converters:
        
         function out=brml.logconst(obj)  % convert const-> logconst
            out=brml.logconst;
            out.table=log(obj.table);
        end
       
        function out=brml.array(obj)  % convert const-> array
            out=brml.array;
            out.variables=obj.variables;
            out.table=obj.table;
        end
        
        function out=brml.logarray(obj)  % convert const-> logarray
            out=brml.logarray;
            out.variables=obj.variables;
            out.table=log(obj.table);
        end
        
        function out=brml.GaussianMoment(obj)  % convert const-> GaussianMoment
            out=brml.GaussianMoment;        
            out.table.logprefactor=log(obj.table);
        end
        
    end
end