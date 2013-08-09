function demoBucketElim
%DEMOBUCKETELIM Demo of Bucket Elimination
load chestclinic
import brml.*
pot=setpotclass(pot,'array');
for finalvar=1:8;
    disp(['Variable ',num2str(finalvar),':'])
    disp('Random Elimination sequence:')
    ord=randperm(8); % random bucket order
    ord(find(ord==finalvar))=ord(end); ord(end)=finalvar;
    tic
    bucket_rand=bucketelim(pot,ord);
    toc
    disptable(bucket_rand{end});
    
    disp(' ');
    disp('Elimination sequence based on minimal neighbours triangulation:')
    ord = elimtri(triangulate(markov(pot)),finalvar);
    tic
    bucket=bucketelim(pot,ord);
    toc
    disptable(bucket{end});
    disp('-----------------');
end