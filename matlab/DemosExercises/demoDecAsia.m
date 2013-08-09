function demoDecAsia
% DEMODECASIA
% Chest Clinic Decision example (see Cowell etal, Prob Networks and Expert Systems, section 8.6)
import brml.*
load chestclinic; figure
pot=setpotclass(pot,'array');
pot=str2cell(pot);

[asia smoker tub lcancer bronch xray dys tlc hosp takexray]=assign(1:10);
probvars = [asia smoker tub lcancer bronch xray dys tlc]; % probability variables
decvars=[hosp takexray]; % decision variables

variable(hosp).name='hospitalize'; variable(hosp).domain={'yes','no'};
variable(takexray).name='take-xray'; variable(takexray).domain={'yes','no'};

%partial ordering: (according to Cowell etal, pg 179)
partialorder{1}.sum=asia;
partialorder{2}.max=takexray;
partialorder{3}.sum=[dys xray];
partialorder{4}.max=hosp;
partialorder{5}.sum=[bronch tlc lcancer smoker tub];

% Cowell uses modifed xray potential to deal with assymetry
pot{xray}.variables=[xray tlc takexray]; % define array below using this variable order
pot{xray}.table(yes, yes, yes)=0.98; pot{xray}.table(yes, no, yes) =0.05;
pot{xray}.table(yes, yes, no) =0.5; pot{xray}.table(yes, no, no)  =0.5;
pot{xray}.table(no,:,:)=1-pot{xray}.table(yes,:,:); % due to normalisation

% We then have a distribution p(1:8|9,10) of variables conditioned on decisions. 
% Now define utilties;
util{hosp}=array([hosp tub lcancer]);
util{hosp}.table(yes, yes, yes)=180;
util{hosp}.table(yes, yes, no) =120;
util{hosp}.table(yes, no, yes) =160;
util{hosp}.table(yes, no, no)  =15;
util{hosp}.table(no, yes, yes) =2;
util{hosp}.table(no, yes, no)  =4;
util{hosp}.table(no, no, yes)  =0;
util{hosp}.table(no, no, no)   =40;
utilinf{hosp}.name='hosp';

util{takexray}=array([takexray tub]);
util{takexray}.table(yes, yes) = 0;
util{takexray}.table(yes, no)=1;
util{takexray}.table(no,yes)=10;
util{takexray}.table(no,no)=10;
utilinf{takexray}.name='take-xray';

% Influence Diagram solved using Junction Tree:
[jtprob jtutil infostruct]=jtreeID(pot,util([hosp takexray]),partialorder); % get the Junction Tree
[jtprob jtutil utilroot]=absorptionID(jtprob,jtutil,infostruct,partialorder); % do absorption

% The root clique is the final clique in the Junction Tree, from which we
% can get the optimal expected utility:
disp(['Junction Tree: Expected Utility (no decisions made) = ' num2str(utilroot)])

% Sum and Max the full joint probability table (generally inefficient):
[newprob newutil] = sumpotID(pot,util([hosp takexray]),[],[],partialorder,0);
fprintf(1,'Check using raw max and sum: Expected Utility (no decisions made) = %g\n',newutil.table)
disp('Reproduce tables in Cowell et al pg 181 (from clique marginal):')
clique = max(whichpot(infostruct.clique,[asia takexray])); % choose clique closest to root which contains the required variables

[newprob newutil] = sumpotID(jtprob(clique),jtutil(clique),asia,takexray,partialorder,0);
str1=disptable(newprob,variable,[takexray asia]);
str2=disptable(newutil,[],[takexray asia]);
disp([char(str1) char(str2)]);

% backtrack decision: after observing asia=no, takexray=no:
disp('Evidence : asia=no, testxray=no. New JT decision potential')
clique = whichpot(mergevariables(jtprob,jtutil),[asia takexray hosp dys xray],1); 
decprob = setpot(jtprob{clique},[asia takexray],[no no]);
decutil = setpot(jtutil{clique},[asia takexray],[no no]);
str1=disptable(decprob,variable,[dys xray]);
str2=disptable(decutil,variable,[hosp dys xray]);
disp('probability table:')
disp(char(str1))
disp('utility table:')
disp(char(str2));
figure(1); drawID(pot,util,partialorder,variable,utilinf);title('DecAsia Influence Diagram')
figure(2); drawJTree(infostruct,variable);title('Strong Junction Tree')