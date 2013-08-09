function demoJTree
%DEMOJTREE  Chest Clinic example using Junction Tree algorithm
import brml.*

load chestclinic; 
pot=str2cell(setpotclass(pot,'array')); % convert to cell array 

[jtpot jtsep infostruct]=jtree(pot); % setup the Junction Tree

jtpot=absorption(jtpot,jtsep,infostruct); % do full round of absorption

figure; drawNet(dag(pot),variable); title('Belief Net');
figure; drawJTree(infostruct,variable); title('Junction Tree (separators not shown)');

% p(dys=yes)
jtpotnum = whichpot(jtpot,dys,1); % find a single JT potential that contains dys
margpot=sumpot(jtpot(jtpotnum),dys,0); % sum over everything but dys

disp(['p(dys=yes) ' num2str(margpot.table(yes)./sum(margpot.table))]);

disp(['can also use log messages:'])
logpot=pot; for i=1:length(pot); logpot{i}.table=log(pot{i}.table+eps); end %add eps in case any zeros
logpot=setpotclass(logpot,'logarray');
[logjtpot logjtsep infostruct]=jtree(logpot); % setup the Junction Tree
logjtpot=absorption(logjtpot,logjtsep,infostruct); % do full round of absorption
jtpotnum = whichpot(logjtpot,dys,1); % find a single JT potential that contains dys
logmargpot=sumpot(logjtpot(jtpotnum),dys,0); % sum over everything but dys
disp(['p(dys=yes) ' num2str(exp(logmargpot.table(yes))./sum(exp(logmargpot.table)))]);

fprintf(1,'\nAs a check, compute using simple summation:\n')
disptable(condpot(multpots(pot),dys),variable);

fprintf(1,'\nAlternatively, we can compute by using setpot, but this changes the structure:\n')
disp('First create a new brml.p(dys=yes,rest)')
newpot=setpot(pot,dys,yes);

disp('To use the JT we must have no missing variables, so squeeze the potential')
[newpot newvars oldvars]=squeezepots(newpot);

[jtpot2 jtsep2 infostruct2]=jtree(newpot); % setup the Junction Tree
[jtpot2 jtsep2 logZ2]=absorption(jtpot2,jtsep2,infostruct2); % do full round of absorption

disp('After absorbing, transform back to original variables')
jtpot2=changevar(jtpot2,newvars,oldvars);
disp('All the cliques have the same normalisation, namely p(dys=yes):')
clear Z; for i=1:length(jtpot2); Z2(i) = table(sumpot(jtpot2{i})); end; Z2





