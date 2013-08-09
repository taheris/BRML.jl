function p=table(pot,varargin)
%TABLE Return the potential table
% p=table(pot,<UniformOutput>)
% set UniformOutput to 0 if pot is a cell that contains tables of different
% size or are non-scalar
% The default is to assume the tables are different.
if iscell(pot)
    if nargin==2
        p = cellfun(@table,pot,'UniformOutput',varargin{1});
    else
        p = cellfun(@table,pot,'UniformOutput',0);
    end
else
    p=pot.table;
end