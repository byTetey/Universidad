function y=deemph(x,a)
%PREEMPH
%
% USAGE:
%   y=deemph(x,a)
%
% where
%   x is the signal to be deemphasised
%   a is an optional deemph value (defaults to 0.97)
%
% SEE ALSO
%   preemph

% Part of MAD V2.1
% MPC 11/6/99

if nargin < 2
 a = 0.97;
end
 
y=filter(1,[1 -a],x);
