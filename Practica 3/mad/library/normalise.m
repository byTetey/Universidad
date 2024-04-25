function y = normalise(x);
%VECTOR=NORMALISE(VECTOR)   
% Normalise VECTOR to range between -1 and 1
%
%  Author: Stuart N Wrigley       
%  MAD - Matlab Auditory Demonstrations
%  (c) University of Sheffield 1998
%  Revision 0.01: 3 July 1998
y = x ./ max(abs(x));


