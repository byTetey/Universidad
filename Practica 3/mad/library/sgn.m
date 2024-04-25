function s=sgn(vector)
%S=SGN(VECTOR)   Calculate the signs of VECTOR
%   sgn{vector(n)} = +1      vector(n) >= 0
%                  = -1      vector(n) < 0
%
%  Author: Stuart N Wrigley       
%  MAD - Matlab Auditory Demonstrations
%  (c) University of Sheffield 1998
%  Revision 0.01: 3 July 1998
temp=sign(vector);
s=temp+(temp==0);
