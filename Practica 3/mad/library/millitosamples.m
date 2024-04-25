function samples=milliToSamples(milli,fs)
%SAMPLES=MILLITOSAMPLES(MILLI,FS) Convert from milliseconds to samples
%
%  Author: Stuart N Wrigley       
%  MAD - Matlab Auditory Demonstrations
%  (c) University of Sheffield 1998
%  Revision 0.01: 3 July 1998

samples=round((fs*milli)/1000);  % round - must be an integer!
