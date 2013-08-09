function newpot = sumpots(pots)
%SUMTPOTS Sum potentials into a single potential
% newpot = sumpots(pots)
%
% pots is a cell vector of potentials
% potentials with empty tables are ignored
import brml.*
pots=str2cell(pots);
newpot=pots{1};
for j=2:length(pots) % loop over all the potentials
    if ~isempty(newpot.table)&&~isempty(pots{j}.table)
        newpot=newpot+pots{j};
    elseif isempty(newpot.table)
        newpot=pots{j};
    end
end