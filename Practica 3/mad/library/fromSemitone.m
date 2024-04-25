function y=fromSemitone(basef,s)
%FROMSEMITONE Converts from semitones to Hz, with
% respect to a base frequency.
%
%    y=fromSemitone(basef,s)
%

y=basef*exp(log(1)+((log(2)-log(1))/13)*s);

