function structure=setfields(structure,mode,varargin)
%SETFIELDS sets the fields of a structure.
% mode is set to either `overwrite' or `insert'
% If set to `insert', setfields does not overwrite existing field values
% example structure = setfields(structure,'insert','name','david','number',1)
% Use structure = setfields([],'insert','name','david','number',1) to create a new structure
% If called with multiple structures, the same operation is applied to each structure
if strcmp(mode,'overwrite')
    overwrite=1;
else
    overwrite=0;
end
if isempty(structure);
    c=1;
    for i=1:floor(length(varargin)/2)
        f=varargin{c}; v=varargin{c+1};
        structure.(f)=v;
        c=c+2;
    end
else
    for p=1:length(structure)
        c=1;
        for i=1:floor(length(varargin)/2)
            emptyfield=0;
            if isfield(structure(p),varargin{c})
                tmp=getfield(structure(p),varargin{c});
                if isempty(tmp); emptyfield=1;
                end
            end
            f=varargin{c}; v=varargin{c+1};
            if isstruct(v)
                fname=fieldnames(v);
                for j=1:length(fname)
                    if ~isfield(structure.(f),fname{j}) || emptyfield || overwrite
                        structure.(f).(fname{j})=v.(fname{j});
                    end
                end
            else
                if ~isfield(structure,varargin{c}) || emptyfield || overwrite
                    structure.(f)=v;
                end
            end
            c=c+2;
        end
    end
end