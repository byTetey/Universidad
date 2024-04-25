%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tone-masking-noise and Noise-masking-tone experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tone generator
   fc = 4000;       % fc in Hz
   alpha = 0.025;  % Tone amplitude
   length = 44099;  % length of the sinusoid 
   fs = 44100;      % sampling rate
   
   % Generate a pure tone
   s1 = sin(2*pi*(fc/fs)*[1 :1 : length])'; 
   
% Broadband noise generator
    beta = 1;
    s2 = [1, zeros(1, length-1)]';
    % Bandpass filter design
    [B, A] = butter(8, [2*3500/44100, 2*4500/44100]);
    s2 = filter(B, A, s2);
    
% Test signal
    s = alpha * s1 + beta * s2;

%ASSIGNMENT:    
% 1. For alpha = 0.025 and beta = 1, does the broad band noise
%    comletely mask the tone??
% 2. Experiment for different values of alpha and beta and find out when
%    the broadband noise masks the tone and the tone masks the noise.

%HINTS:
% 1. Write code to call the psychoacoustics.m to perform
%    psychoacoustic anlaysis.
% 2. For the TMN and NMT cases, plot the global masking threshold 
%    of the test signal and study how the masking curve associated with noise
%    falls below that of the tone for tone masking noise case. Also analyze the noise
%    masking tone scenario.