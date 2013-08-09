function gradloglik=linearCRFgrad(x,y,lambda,A,dimx,dimy)
%LINEARCRFGRAD linear conditional random field gradient
%gradloglik=linearCRFgrad(x,y,lambda,A,dimx,dimy)
%See demoLinearCRF.m
import brml.*
N=length(x);
gradloglik=zeros(length(lambda),1);
for n=1:N
    T=length(y{n});
    phi = definePhiFromLambda(x{n},T,lambda,dimx,dimy );
    % pair marginal probability:
    [marg mess]=sumprodFG(phi,A{n});
    
    for t=1:T
        % when t=1, compute gradient for single unary feature
        % empirical part, fine with t=1
        indf=linearCRFfeatureIDX(x{n},y{n},t,dimx,dimy);
        gradloglik(indf) = gradloglik(indf) +1;
        
        % expectation part
        [v var2fact fact2var] = VariableConnectingFactor(t,A{n});
        potmarg=condpot(multpots([phi(t) mess(var2fact)]));% marginal is the potential multiplied by incoming messages
        tab=potmarg.table;
        ytmp=y{n};
        for yt=1:dimy
            if t==1 % don't worry about varying y(t-1)
                ytmp(t)= yt;
                indf=linearCRFfeatureIDX(x{n},ytmp,t,dimx,dimy);
                gradloglik(indf) = gradloglik(indf) - tab(yt);
            else
                for ytm=1:dimy
                    ytmp(t-1)= ytm; ytmp(t)= yt;
                    indf=linearCRFfeatureIDX(x{n},ytmp,t,dimx,dimy);
                    gradloglik(indf) = gradloglik(indf) - tab(ytm,yt);
                end
            end
        end
    end
end