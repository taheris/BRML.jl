function out = evalpot(pot,varargin)
%EVALPOT Evaluate the table of a potential 
% out = evalpot(pot,<evvariables>,<evidence>)
% For const potentials, simply returns the constant scalar value
out=pot.table;