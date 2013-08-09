function a=ancestors(x,A)
%ANCESTORS Return the ancestors of nodes x in DAG A
% a=ancestors(x,A)
% eg a = ancestors([1 2],A)
import brml.*
done=false;
a=parents(A,x); % start with the parents of x
while ~done
    aold=a;
    a=union(a,parents(A,a)); % include the parents of the current ancestors
    done=isempty(setdiff(a,aold)); % if this doesn't introduce any more nodes, we're done
end
a=setdiff(a,x);