function c=cell2str(x)
% convert a structure vector to a cell vector
if isstruct(x); c=x; return;
else
    if length(x)>1
        for i=1:length(x)
            c(i)=x{i};
        end
    else
        c=x;
    end
end

