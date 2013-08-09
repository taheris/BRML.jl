function pot=linearCRFpotential(x,t,lambda,dimx,dimy)
%LINEARCRFPOTENTIAL a particuarly simple linear chain CRF potential
import brml.*
pot=array;
if t>1
    pot.variables=[t-1 t];
    for ytm=1:dimy
        for yt=1:dimy
            y(t)=yt; y(t-1)=ytm;
            indf=linearCRFfeatureIDX(x,y,t,dimx,dimy);
            pot.table(ytm,yt)=exp(sum(lambda(indf)));
        end
    end
else
    pot.variables=t;
    for yt=1:dimy
        y(t)=yt;
        indf=linearCRFfeatureIDX(x,y,t,dimx,dimy);
        pot.table(yt)=exp(sum(lambda(indf)));
    end
end