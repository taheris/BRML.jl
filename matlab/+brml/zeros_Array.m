function out=zeros_Array(numstates)
%ZEROS_ARRAY sames as zeros(x), but if x is a scalar, interprets as zeros([x 1])
if length(numstates)>1
    out=zeros(numstates);
else
    out=zeros([numstates 1]);
end