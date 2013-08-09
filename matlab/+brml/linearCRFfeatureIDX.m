function indf=linearCRFfeatureIDX(x,y,t,dimx,dimy)
% The linear chain CRF fecture vector indices
indxy = reshape(1:dimx*dimy,dimx,dimy);
indyy = reshape(1:dimy*dimy,dimy,dimy);
indf(1,1) = indxy(x(t),y(t));
if t>1
    indf(2,1)=dimx*dimy+indyy(y(t-1),y(t));
end