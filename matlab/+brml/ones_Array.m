function out=ones_Array(numstates)
%ONES_ARRAY sames as ones(x), but if x is a scalar, interprets as ones([x 1])
if length(numstates)>1
    out=ones(numstates);
else
    out=ones([numstates 1]);
end