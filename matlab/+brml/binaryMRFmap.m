function [x E]=binaryMRFmap(W,b,varargin)
%BINARYMRFMAP get the MAP assignment for a binary MRF with positive W
% [x E] = binaryMRFmap(W,b,<icm>,<opts>)
% x=argmax sum_{ij} W(i,j)[x(i)==x(j)]+ sum_i b(i)x(i), x(i)={0,1},W(i,j)>0
% E is the value of the objective at x
% Default assumes W is positive and min-cut algorithm is used
% if icm=1, then use Iterative Conditional Modes algorithm with 
% opts.xinit, opts.maxit, opts.minit
import brml.*
if nargin==2; icm=0; else icm=varargin{1}; opts=varargin{2}; end
N = length(b);
if ~icm & ~all(W(:)>=0)
    error('Cannot use min-cut algorithm since not all elements of W are positive. Please call with ICM set to 1')
end
if all(b>0)
    x=ones(N,1);
else
    if ~icm & all(W(:)>=0) % if positive and requested we can use the Min-cut approach
        [s t]=assign([N+1 N+2]); % source and sink
        WW=zeros(N+2); WW(1:N,1:N)=W;
        WW(s,b>0)=b(b>0); WW(b<0,t)=-b(b<0); % attach source and sink
        [f F cutS]=MaxFlow(WW'+WW,s,t); % min cut
        x = zeros(N,1); x(setdiff(cutS,s))=1;
    else
        xold=opts.xinit;
        for loop=1:opts.maxit;
            x=xold;
            r=randperm(N);
            for j=1:N
                i=r(j); 
                if b(i)+W(:,i)'*(2*x-1)>0
                    x(i)=1; else x(i)=0;
                end   
            end
            if all(x==xold) & loop>opts.minit; break; end
           
        end
    end
end
E = 2*x'*(W*x)-x'*sum(W,2)-sum(W,1)*x+sum(sum(W))+b(:)'*x;