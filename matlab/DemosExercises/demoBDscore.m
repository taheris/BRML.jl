function demoBDscore
%DEMOBDSCORE demo of the BD score structure learning algorithm
import brml.*
load LearnBayesNetData; figure
pot=setpotclass(pot,'array');
A = dag(pot); [xcord,ycord]=draw_layout(A); title('oracle');
V=size(A,1); data=data(:,1:100);
Alearn=brml.learnBayesNet(data,ancestralorder(A),nstates,2*ones(1,V),1);
figure; draw_layout(Alearn,cellstr(int2str((1:V)')),zeros(1,V),xcord,ycord);
title(['Bayes Dirichlet: Learned Structure from ',num2str(size(data,2)),' examples'])
fprintf('score = %f\n',BayesNetScore(data,Alearn,nstates,1))