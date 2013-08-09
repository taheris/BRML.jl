function [ phi ] = definePhiFromLambda( x, T, lambda, dimx, dimy )
%DEFINEPHIFROMLAMBDA( x, T, lambda, dimx, dimy )
%   Define the set of potentials for a linear chain CRF
for t=1:T; phi{t}=brml.linearCRFpotential(x,t,lambda,dimx,dimy); end