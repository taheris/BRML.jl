function y=mylogsig(x)
x=brml.cap(x,500);
if x>0
    y=x-log(1+exp(x));
else
    y=-log(1+exp(-x));
end