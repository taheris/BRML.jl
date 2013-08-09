function newpot = sum(pot,variables)
%SUM Sum potential over variables
% newpot = sum(pot,variables)
% example: pot=logarray([1 2],rand(2,2)); newpot=sum(pot,1);
% this sums the potential over variable 1, leaving a potential on variable 2
logprefactor=max(pot.table(:));
pot.table=exp(pot.table-logprefactor);
newpot=brml.logarray;
newpot.variables=brml.setminus(pot.variables,variables); % new potential variables
table_variables=find(ismember(pot.variables,variables));   % indices of the table that will be summed over
s = size(pot.table);
if length(size(pot))==1 && s(1)==1 % if there is only one variable it might be stored as a row vector
    t=pot.table'; % flip to make row vector
else
    t=pot.table; % get the table array
end
for v=table_variables
    t=sum(t,v); % resursively sum over the variables
end
newpot.table=squeeze(t); % remove any redunant vacuous remaining indices
s = size(newpot.table);
if s(1)==1; newpot.table=newpot.table'; end % return column vector if possible
newpot.table=log(newpot.table)+logprefactor;
if isempty(newpot.variables); 
    newpot=brml.logconst(newpot.table);
end