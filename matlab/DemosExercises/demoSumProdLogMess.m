function demoSumProdLogMess
%DEMOSUMPRODLOGMESS Sum-Product algorithm test using log messages :
import brml.*
close all
figure
% Variable order is arbitary
variables=1:5; [a b c d e]=assign(variables);
nstates=ceil(3*rand(1,5)+1); % random number of states for each variable

pot{1}=array([a b],rand(nstates([a b])));
pot{2}=array([b c d],rand(nstates([b c d])));
pot{3}=array(c,rand(nstates(c),1));
pot{4}=array([e d],rand(nstates([e d])));
pot{5}=array(d,rand(nstates(d),1));

for i=1:5;
    logpot{i}=logarray(pot{i});
end

subplot(1,2,1); drawNet(markov(pot)); title('Markov Network');
A = FactorGraph(pot); subplot(1,2,2); drawFG(A); title('Factor Graph');

[marg mess normconst]=sumprodFG(pot,A);
[logmarg logmess lognormconst]=sumprodFG(logpot,A);

jointpot = multpots(pot); V=length(pot);
for i=1:V
    margpot{i}= condpot(jointpot,i);
    logmargpot{i}=condpot(logmarg{i},i);
    logmargpot{i}.table=exp(logmargpot{i}.table);
    
    str1=disptable(condpot(marg{i},i),[]);
    str2=disptable(margpot{i},[]);
    str3=disptable(logmargpot{i},[]);
    
    disp([' marginal of variable ',num2str(i),' FG (left) Raw summation (middle) FG log messages (right) :']);
    disp([char(str1) char(str2) char(str3)]); 
end

disp('Log Normalisation constant (raw summation):')
log(table(sumpot(jointpot)))

disp('Log Normalisation constant (FG log messages):')
table(lognormconst)




