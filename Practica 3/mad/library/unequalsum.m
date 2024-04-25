function z=unequalsum(x,y)
% Z=UNEQUALSUM(X,Y)
% Adds vectors x and y in case where they are differing lengths 
%
%  Author: Martin Cooke       
%  MAD - Matlab Auditory Demonstrations
%  (c) University of Sheffield 1998
%  Revision 0.01: 3 June 1998

x=x(:);
y=y(:);
if length(x) > length(y)
  z = x;
  z(1:length(y)) = z(1:length(y))+y;
else
  z = y;
  z(1:length(x)) = z(1:length(x))+x;
end
