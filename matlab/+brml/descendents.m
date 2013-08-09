function d=descendents(x,A)
%DESCENDENTS Return the descendents of nodes x in DAG A
% d=descendents(x,A)
% see also ancestors.m
import brml.*
done=false;
d=children(A,x); % start with the children of x
while ~done
    dold=d;
    d=union(d,children(A,d)); % include the parents of the current ancestors
    done=isempty(setdiff(d,dold)); % done if this doesn't introduce any more nodes
end
d=setdiff(d,x);