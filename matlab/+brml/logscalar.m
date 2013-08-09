function x=logscalar(pot)
if iscell(pot)
    x=cellfun(@logscalar,pot);
else
    x=pot.table;
end