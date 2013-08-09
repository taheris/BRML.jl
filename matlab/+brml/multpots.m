function newpot = multpots(pots)
%MULTPOTS Multiply potentials into a single potential
% newpot = multpots(pots)
%
% multiply potentials : pots is a cell of potentials
% potentials with empty tables are ignored
% if a table of type 'zero' is encountered, the result is a table of type
% 'zero' with table 0, and empty variables.

pots=brml.str2cell(pots); % backward compatability
newpot=pots{1};
for j=2:length(pots) % loop over all the potentials
    
    if isa(pots{j},'brml.const')
        switch pots{j}.table
            case 0
                newpot=brml.const(0);
                break;
            case 1
                continue
            otherwise
                newpot=newpot*pots{j};
        end
    elseif ~isempty(pots{j}.table)
        newpot=newpot*pots{j};
    end
end
