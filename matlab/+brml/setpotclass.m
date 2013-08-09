function newpots=setpotclass(pots,potclass)
% newpots=SETPOTCLASS(pots,potclass)
import brml.*
if length(pots)==1
    
    newpots=feval(['brml.' potclass]);
    
    if isstruct(pots)
        if ~isempty(pots)
            newpots.variables=pots.variables;
            newpots.table=pots.table;
        end
    end
    
    if iscell(pots)
        if ~isempty(pots)
            newpots.variables=pots.variables;
            newpots.table=pots.table;
        end
    end
    
else
    if iscell(pots)
        for i=1:length(pots)
            newpots{i}=feval(['brml.' potclass]);
            if ~isempty(pots{i})
                newpots{i}.variables=pots{i}.variables;
                newpots{i}.table=pots{i}.table;
            end
        end
    else
        for i=1:length(pots)
            newpots(i)=feval(['brml.' potclass]);
            if ~isempty(pots(i))
                newpots(i).variables=pots(i).variables;
                newpots(i).table=pots(i).table;
            end
        end
        
    end
end