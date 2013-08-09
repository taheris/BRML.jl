function c=str2cell(x)
% convert a structure vector to a cell vector
if iscell(x); c=x; return;
else
    for i=1:length(x)
        c{i}=x(i);
    end
end