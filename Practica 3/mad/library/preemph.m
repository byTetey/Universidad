function y=preemph(x,a)
%PREEMPH
%
% USAGE:
%   y=preemph(x,a)
%
% where
%   x is the signal to be preemphasised
%   a is an optional preemph value (defaults to 0.97)
%
% SEE ALSO
%   deemph

% Part of MAD V2.1
% MPC 11/6/99

if nargin < 2
 a = 0.97;
end
 
y=filter([1 -a],1,x);
