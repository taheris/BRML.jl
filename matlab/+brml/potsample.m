function x=potsample(pot,nsamples)
%POTSAMPLE Draw exact samples from a Markov network
% x=potsample(pot,nsamples)
% Uses Junction Tree to perform exact sampling
import brml.*
pot=str2cell(pot);
if length(pot)==1
    x=sample(pot{1},nsamples);
else
    [jtpot jtsep infostruct]=jtree(pot); % setup the Junction Tree
    jtpot=absorption(jtpot,jtsep,infostruct); % do full round of absorption
    x=JTsample(jtpot,infostruct,nsamples); % sample from the Junction Tree
end