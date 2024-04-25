function milli=samplesToMilli(samples,fs)
%MILLI=SAMPLESTOMILLI(SAMPLES,FS) Convert from samples to milliseconds
%
%  Author: Stuart N Wrigley       
%  MAD - Matlab Auditory Demonstrations
%  (c) University of Sheffield 1998
%  Revision 0.01: 3 July 1998
milli=(1000*samples)/fs;
