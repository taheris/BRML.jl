function drawID(pot,util,partialorder,varinf,utilinf)
%DRAWID plot an Influence Diagram
% drawID(prob,util,partialorder,varinf,utilinf)
% Chance nodes are ovals. Non-chance (decisions and utilities are boxes)
import brml.*
varinf=str2cell(varinf);
utilinf=str2cell(utilinf);

[probvars decvars]=IDvars(partialorder);

nvars = length(probvars)+length(decvars);
for i=1:length(decvars)
    pot{decvars(i)}=array(decvars(i));
end

pot=changevar(pot,[probvars decvars],1:nvars);
util=changevar(util,[probvars decvars],1:nvars);
varinf=varinf([probvars decvars]);
pot=pot([probvars decvars]);

probvars=1:length(probvars); decvars=probvars(end)+1:probvars(end)+length(decvars);

count=0;
for i=1:length(util)
    if ~isempty(util{i})
        count=count+1;
        tmppot=array([nvars+count util{i}.variables]);
        pot=[pot {tmppot}];
        if ~isempty(utilinf{i})
            varinf{nvars+count}.name=['util: ',utilinf{i}.name];
        else
            varinf{nvars+count}.name=['util: ',num2str(count)];
        end
    end
end

nodetype=ones(1,length(pot));
for i=1:length(varinf)
    label{i} = field2cell(varinf{i},'name');
    if ismember(i,probvars); nodetype(i)=0; end
end

draw_layout(dag(pot),label,nodetype);
