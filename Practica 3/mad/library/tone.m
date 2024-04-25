function x=tone(freq,level,dur,fs)
%TONE generates a tone
%
% USAGE
%     x=tone(freq,level,dur,fs)
%
% All parameters are optional, with defaults:
%
%   freq      frequency     (1 kHz)
%   level     level         (70 dB re 80dB=1)
%   dur       duration      (200 ms)
%   fs        sampling freq (8192 Hz)

if nargin < 4
  fs=8192;
end  
if nargin < 3
  dur = 200;
end
if nargin < 2
  level = 70;
end
if nargin < 1
  freq = 1000;
end

sdur=round(fs*dur/1000);
x=db2amp(level,80).*sin(2*pi*(freq/fs)*(1:sdur));
