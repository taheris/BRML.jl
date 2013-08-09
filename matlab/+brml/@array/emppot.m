function epot=emppot(pot,data,v,nstates)
% epot=emppot(pot,data,v,nstates)
% example: data=[1 2 1 2 1 2 1 2 1; 2 1 1 2 2 1 1 2 2];
% emppot(array,data,1,2) returns a potential for variable 1 (which takes 2
% states) based on counting the number of occurences of variable 1 in the
% data.
% example: emppot(array,data,[1 2],[2 2])
% see also count.m
if length(nstates)>1
    px=reshape(brml.normp(brml.count(data(v,:),nstates)),nstates);
else
    px=brml.normp(brml.count(data(v,:),nstates));
end
epot=brml.array(v,px);