function demoMFBPGibbs
%DEMOMFBPGIBBS demo comparing Mean Field, Belief Propagation and Gibbs Sampling
import brml.*
figure(1)
nstates=6;
[W X Y Z]=assign(nstates*ones(1,4)); % number of states of each variable
[w x y z]=assign(1:4);

% set the potentials to random tables:
a=25;
phi{1}=array([w x],rand([W X]).^a);
phi{2}=array([x y],rand([X Y]).^a);
phi{3}=array([y w],rand([Y Z]).^a);
phi{4}=array([z w],rand([Z W]).^a);
phi{5}=array([w y],rand([W Y]).^a);

p = condpot(multpots(phi)); % normalise so we can monitor the KL exactly

% approximating q structure:
qw=array(w,normp(rand([W 1])));
qx=array(x,normp(rand([X 1])));
qy=array(y,normp(rand([Y 1])));
qz=array(z,normp(rand([Z 1])));

xcord=[0.2 0.2 0.8 0.8]; ycord=[0.2 0.8 0.2 0.8];
subplot(1,2,1); draw_layout(markov(p)-eye(4),{'w','x','y','z'},zeros(4,1),xcord,ycord); title('original graph')
subplot(1,2,2); draw_layout(markov([qw qx qy qz])-eye(4),{'w','x','y','z'},zeros(4,1),xcord,ycord); title('Factorised graph')
figure(2)
for loop=1:50
    ord=randperm(4);
    for o=ord
        switch o
            case 1
                qw = condpot(exppot(sumpot(multpots([logpot(p) qx qy qz]),w,0),1));
            case 2
                qx = condpot(exppot(sumpot(multpots([logpot(p) qw qy qz]),x,0),1));
            case 3
                qy = condpot(exppot(sumpot(multpots([logpot(p) qx qw qz]),y,0),1));
            case 4
                qz = condpot(exppot(sumpot(multpots([logpot(p) qx qy qw]),z,0),1));
        end
    end
    kl(loop) = KLdiv(multpots([qw qx qy qz]),p);
    plot(kl,'-o'); title('KL divergence');drawnow
end
[margMF{1} margMF{2} margMF{3} margMF{4}]=assign([qw qx qy qz]);
% BP: (easier to write a general code based on the FG method).
opt.tol=10e-10; opt.maxit=50;
figure;
[marg mess A2]=LoopyBP(phi,opt);
title('BP marginal convergence'); drawnow

% Gibbs sampling:
sample(:,1)=real(rand(4,1)>0.5)+1;
C{1}=[x y z]; C{2}=[w y z]; C{3}=[w x z]; C{4}=[x y w];
sample=GibbsSample(p,sample(:,1),C,50);
for i=1:4
    margGibbs{i}=condp(count(sample(i,:),nstates)');
end

jpot=multpots(phi);
fprintf('\nExact and Loopy BP marginals and MF marginals:\n\n')
for i=1:length(potvariables(phi))
    fprintf('variable %d:\n    Exact     Loopy BP     MF     Gibbs\n',i);
    disp([table(condpot(jpot,i)) table(marg{i}) table(margMF{i}) margGibbs{i}])
    errBP(i)=mean(abs(table(condpot(jpot,i))-table(marg{i})));
    errMF(i)=mean(abs(table(condpot(jpot,i))-table(margMF{i})));
    errGibbs(i)=mean(abs(table(condpot(jpot,i))-margGibbs{i}));
end
fprintf('mean error BP = %g\n',mean(errBP))
fprintf('mean error MF = %g\n',mean(errMF))
fprintf('mean error Gibbs= %g\n',mean(errGibbs))
figure; t=table(multpots(p)); plot(t(:),'-o'); title('p distribution')