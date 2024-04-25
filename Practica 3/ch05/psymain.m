% MATLAB SIMULATION OF ISO/IEC MPEG-1 PSYCHOACOUSTIC MODEL-1
% COPYRIGHT (C) 2003-07  VENKATRAMAN ATTI and ANDREAS SPANIAS
%
% This Copyright applies only to this particular MATLAB implementation
% of the Psychoacoustic model-1.  The MATLAB software is intended only for educational
% purposes.  No other use is intended or authorized.  This is not a public
% domain program and unauthorized distribution to individuals or networks 
% is prohibited. Be aware that use of the standard in any form is goverened
% by rules of the ISO/IEC MPEG Committee.  
% This program is free software. It is distributed in the hope that it will
% be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  There is no commitment 
% or even implied commitment on behalf of Venkatraman Atti or Andreas Spanias
% for maintenance or support of this code.
%
% MATLAB is trademark of The Mathworks Inc
%
% ALL DERIVATIVE WORKS MUST INCLUDE THIS COPYRIGHT NOTICE.
% ******************************************************************
% ISO/IEC 11172-3 (MPEG-1) Psychoacoustic Model-1
% ******************************************************************
% %--------------------------------------------------------------------------------------------------
% % - Perceptual audio analysis/synthesis using psychoacoustic principles as used in an MP3 player
% % - EEE 407 DSP  (Fall 2004) project designed by Venkatraman Atti and Andreas Spanias
% % Enter your Name: [  xxxx ];   Your ASU ID:  [  xxxx  ] 
% %--------------------------------------------------------------------------------------------------
% Please note that this Matlab file (i.e., psymain.m) is provided to you to use it as a skeleton
% Please use the guidlines given in the Project write-up to fill in the appropriate commands
%
% This file is organized as follows:
% Section - I     : Read an audio file date into variable 's'
% Section - II   : Frame-by-frame processing
% Section - III : audio synthesis

% Description of some of the variables

pause on;

%***************************************************************************
	clear all,      % clears all the variables
	close all,      % closes all the open Matlab-related windows
	clc,            % clears the workspace (but the variables won't be erased)

%----------------------------------------------  Audio file read command ------>>>>>>>>>>> (Section - I)
	%[s, fs] = audioread('ch5_music.wav');       % Read the wave file into data vector s
    [s, fs] = audioread('audio5.wav');  
%............................................................................................................................................ (Section-I ends)

%---------------------------------------------- Variable declarations
	N = 512;                  % Frame length
  fft_size = 512;               % FFT size
	No_frames = floor(length(s) / N);         % Total number of frames
	Output_audio = [ ];     % Final synthesized audio stream (declared as null for concatenation)

    
%----------------------------------- Frame-by-frame processing ------>>>>>>>>>>> (Section - II)

for i_c = 54 : 1 : No_frames
	sprintf('Frame count = %d', i_c)           % This line is to view the frame count
    
    
    % Step-1 :This is similar to the framing that you performed in your earlier Matlab exercise
        current_frame = s((i_c-1)*N+1 : i_c*N);
    
        
    % Step-2 : Compute the FFT spectrum of the input frame
       current_fr_FFT = fft(current_frame, fft_size);             % performing FFT
       P_spectrum = 10*log10( (abs(current_fr_FFT)).^2 );         % computing the FFT log magnitude spectrum
       FFT_phase = angle(current_fr_FFT);

        
    %Step-3 : Psychoacoustic analysis
        view_fig = 1;       % use view_fig = 1;  if you would like to view the step-by-step computation of the JND;
                                  % use view_fig = 0;  if you do not want to view the figures 
        [P_SPL, JND] = psychoacoustics(current_frame, fft_size, view_fig);  
	
%*****Important NOTE and a few TIPS to complete step-4: perceptual audio synthesis ==>>
% 1. The P_SPL and the JND  outputs from step-3 are both magnitudes in dB SPL; and the size of both the vectors is [1 x 257]
% 2. You need to compute an FFTvector of size [1 x 512] from the above two magnitude vectors and the FFT_phase generated in step-2
% 3. See in your Project Description, Section 2.1, Part-B for a detailed procedure to complete Audio Synthesis

    % Step-4: Perceptual audio synthesis
    Synth_audio = audio_synthesis(P_SPL, JND,FFT_phase, fft_size);
    
    % Include the scale factor 'fft_size' to undo the 
    % amplitude normalization during step-1
    Synth_audio = Synth_audio * fft_size;       % Don't change this
    
    % Buffering; Concatenate all the synthesized frames.
    Output_audio = [Output_audio, Synth_audio'];

    
% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Include your FIGURE statements here.... below
% % for example,
%         figure(1),      % Figure to plot the input frame 
%         plot(current_frame), hold on, plot(Synth_audio, 'k:'), hold off,
%     
%     pause,
end

fprintf('press any key to listen to the input audio \n'), pause,
fprintf('Playing input file... Wait until it is done.... \n')
soundsc(s, fs)
fprintf('After the input file playback is complete, press any key to listen to the Output audio'), pause,
soundsc(Output_audio, fs)

