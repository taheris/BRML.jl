function demoLinearCRF
%DEMOLINEARCRF demo of fitting a linear chaing Conditional Random Field
% See example 9.11 in BRML first edition
% Note that this model differs very slightly to equation 9.6.62 in the
% BRML first edition. Here we include an additional factor at time t=1,
% namely exp(\sum_l \rho_l h_l(y_1,x_1))
import brml.*
fprintf(1,'Linear Chain CRF demo. See example 9.11 in BRML first edition.\nMaximum likelihood training is achieved using simple gradient ascent.\n\n')
figure
% make some training data by sampling from a linear Chain CRF
dimx=5;dimy=3;
lambdatrue=1*(randn(dimx*dimy+dimy*dimy,1));
N=5;
for n=1:N
    %T(n)=ceil(10*rand)+2; % length of the sequence
    T(n)=10; % length of the sequence
    x{n}=randgen(ones(1,dimx),1,T(n));
    phi=definePhiFromLambda(x{n},T(n),lambdatrue,dimx,dimy);
    y{n}=potsample(phi,1);  % draw a sample
    Atrain{n} = FactorGraph(phi);
end

% gradient check:
if 1==0
    fprintf(1,'doing gradient check...')
    lambda=lambdatrue;
    gtrue=linearCRFgrad(x,y,lambda,Atrain,dimx,dimy);
    del=0.001;
    for i=1:length(lambda)
        lambdanew=lambda; lambdanew(i)=lambdanew(i)-del;
        LM = linearCRFloglik(x,y,lambdanew,Atrain,dimx,dimy);
        lambdanew=lambda; lambdanew(i)=lambdanew(i)+del;
        LP = linearCRFloglik(x,y,lambdanew,Atrain,dimx,dimy);
        g(i,1)=(LP-LM)/(2*del);
    end
    fprintf(1,'error = %f\n',mean(abs(g-gtrue)));
end


% simple gradient ascent training: (In practice its better to use a more
% powerful method, for example conjugate gradients or a Newton approach)
eta=1; % learning rate
lambda=zeros(dimx*dimy+dimy*dimy,1); % initialise the parameters

loglikold=-inf;
for loop=1:20
    loglik(loop)=nan;
    lambdatmp=lambda + eta*linearCRFgrad(x,y,lambda,Atrain,dimx,dimy); % gradient ascent
    logliktmp=linearCRFloglik(x,y,lambdatmp,Atrain,dimx,dimy);
    if logliktmp>loglikold
        loglik(loop)=logliktmp;
        loglikold=logliktmp;
        lambda=lambdatmp;
        plot(loglik,'-o'); ylabel('log likelihood'); drawnow
    else
        eta=eta/2;
        fprintf(1,'Likelihood descreased, so lower the learning rate to %f\n',eta);
    end
end
% Find the most likely output sequence given each training input sequence
figure;
for n=1:N
    phi=definePhiFromLambda(x{n},T(n),lambda,dimx,dimy);
    fprintf(1,'training sequence %d:\n',n)
    disp(['input         :',num2str(x{n}(:)')]);
    disp(['true output   :',num2str(y{n}(:)')]);
    ymax{n}=maxprodFG(phi,Atrain{n});
    disp(['CRF MAP output:',num2str(ymax{n})]);
    out(1,:)=x{n};
    out(2,:)=y{n};
    out(3,:)=ymax{n};
    subplot(N,1,n);imagesc(out);
end
subplot(N,1,1); title('train performance')

fprintf(1,'\nTest the generalisation:\n');
for n=1:N
    %clear phi
    %T(n)=ceil(10*rand)+2;
    T(n)=10;
    xtest{n}=randgen(ones(1,dimx),1,T(n));
    phi=definePhiFromLambda(xtest{n},T(n),lambdatrue,dimx,dimy);
    Atest{n}=FactorGraph(phi);
    ytest{n}=potsample(phi,1);  % draw a sample
end
% Find the most likely output sequence given each training input sequence
figure;
for n=1:N
    phi=definePhiFromLambda(xtest{n},T(n),lambda,dimx,dimy);
    fprintf(1,'test sequence %d:\n',n)
    disp(['input         :',num2str(xtest{n}(:)')]);
    disp(['true output   :',num2str(ytest{n}(:)')]);
    ytestmax{n}=maxprodFG(phi,Atest{n});
    disp(['CRF MAP output:',num2str(ytestmax{n})]);
    clear out
    out(1,:)=xtest{n};
    out(2,:)=ytest{n};
    out(3,:)=ytestmax{n};
    subplot(N,1,n); imagesc(out);
end
subplot(N,1,1); title('test performance')
