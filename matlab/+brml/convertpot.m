function newpot = convertpot(inpot,outpotclass)
%CONVERTPOT Convert a (set of) potential(s) to another form
% newpot = convertpot(inpot,outpotclass)
% example newpot=converpot(pot,'array')
inpot=brml.str2cell(inpot);
for i=1:length(inpot)
    newpot{i}=feval(['brml.' outpotclass],inpot{i});
end
