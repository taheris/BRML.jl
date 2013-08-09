function empMI=MIemp(dataX,dataY,X,Y)
%MIEMP Compute the Mutual Information of the empirical distribution on discrete variables
% empMI=MIEmp(dataX,dataY,X,Y)
% here dataX,dataY are data matrices where each row contains the sample states
% with the number of their states in X,Y
import brml.*
pxy=reshape(normp(count(vertcat(dataX,dataY),[X Y])),[X Y]); % empirical distribution
x = 1:length(X); y = x(end)+1:x(end)+length(Y);
emppot=array([x y],pxy); empMI = condMI(emppot,x,y,[]);