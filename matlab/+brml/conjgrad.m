function [x, val]=conjgrad(A,b,x0,opts)
%CONJGRAD conjugate gradients for minimising a quadratic 0.5*x'*A*x-x'*b for positive definite A
% [x, val]=conjgrad(A,b,x0,opts)
% x0 is the initial starting solution
% x is the return solution, and val the function value 0.5*x'*A*x-x'*b
% opts.plotprogress: set to 1 to see the evolution of the quadratic
% opts.maxits : maximum number of iterations
% opts.tol : termination criterion for change in 0.5*x'*A*x-x'*b
x=x0;
g=A*x-b;
p=-g;
vals=[];
for loop=1:opts.maxits
    alpha=-(p'*g)/(p'*A*p);
    x=x+alpha*p;
    gnew=A*x-b;
    beta=(gnew'*gnew)/(g'*g);
    p=-gnew+beta*p;
    g=gnew;
    val = 0.5*x'*(g-b);
    if opts.plotprogress; vals=[vals val]; plot(vals,'-o'); title('Objective function value'); drawnow; end
    if loop>1
        if vals(loop-1)-val<opts.tol; break; end
    end
end