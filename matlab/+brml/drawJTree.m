function drawJTree(infostruct,varargin)
%DRAWJTREE plot a Junction Tree
% drawJTree(jtpot,infostruct,<varinf>)
import brml.*
if length(infostruct.cliquevariables)>1
    for i=1:length(infostruct.cliquevariables);
        if nargin==2;
            a = field2cell(varargin{1}(infostruct.cliquevariables{i}),'name');
        else
            a = cellstr(num2str(infostruct.cliquevariables{i}));
        end
        c=[];for j=1:length(a)-1; c =[c a{j} ' ']; end;  c =[c a{end}];
        label{i}=[num2str(i),' [',c,']'];
    end
else
    if nargin==2;
        a = field2cell(varargin{1}(infostruct.cliquevariables),'name');
    else
        a = cellstr(num2str(infostruct.cliquevariables));
    end
    c=[];for j=1:length(a)-1; c =[c a{j} ' ']; end;  c =[c a{end}];
    label{1}=[num2str(1),' [',c,']'];
end
cla; draw_layout(infostruct.cliquetree,label);