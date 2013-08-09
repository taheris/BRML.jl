function [marg mess A]=LoopyBP(pot,varargin)
%LOOPYBP loopy Belief Propagation using sum-product algorithm
%[marg mess A]=LoopyBP(pot,<opts>)
% options: opts.maxit, opts.tol, opts.plotprogress
import brml.*
opts=[];if nargin==2; opts=varargin{1}; end
opts=setfields(opts,'insert','maxit',5*length(pot),'tol',1e-10,'plotprogress',1);% default options
A = FactorGraph(pot);
nmess = full(sum(A(:)~=0)); % total number of messages
messlidx = find(A); % message indices
del=[];
for loop=1:opts.maxit
    r=1:nmess;
    %r=randperm(nmess); % random message schedule (leave random spanning tree schedule as an exercise)
    for i=1:nmess
        A(messlidx(i))=r(i); % place message index on A
        k(r(i))=i; % number the messages accordingly
    end
    if loop>1
        [marg mess(k)]=sumprodFG(pot,A,mess(k));
        mess=condpot(mess);
        marg=condpot(marg);
        if isa(marg,'brml.array') || isa(marg,'brml.logarray')
            margtable=horzcat(cellfun(@table,marg,'UniformOutput',false));
            oldmargtable=horzcat(cellfun(@table,oldmarg,'UniformOutput',false))
            if mean(abs(margtable-oldmargtable))<opts.tol; break; end
            if opts.plotprogress
                del=[del mean(abs(vertcat(marg.table)-vertcat(oldmarg.table)))];
                plot(del,'-o');
            end
        end
    else
        [marg mess]=sumprodFG(pot,A); mess(k)=mess;
        mess=condpot(mess);
        marg=condpot(marg);
    end
    oldmarg=marg;
end
mess=mess(k);