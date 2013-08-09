function s=mysize(x)
if isvector(x)
    s=length(x);
else
    s=size(x);
end