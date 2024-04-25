

function Synth_audio = audio_synthesis(P, Thr_global, cf_angle, fft_size)

% The "for" loop below performs the perceptual selection criteria
% i.e., if the is less than the global threshold, then set p to -50dB SPL
count = 0;
% figure(1), plot(P), hold on, plot(Thr_global,'r:'), hold off,

for i = 1 : 1 : length(P)
    if ( P(i) < Thr_global(i) )
        count = count + 1;
        P(i) = -50;
    end
end
count
% (***Part-1***)
% This is to undo the normalization performed in the psychoacoustic analysis 
% and to convert P from dB SPL to real values 

P = (10.^((P-90.302)/10)).^(0.5);

%(***Part-2***)
% compensate for the phase that we took out during the PSD computation

P = P .* cos(cf_angle(1:fft_size/2+1)) + j * P .*sin(cf_angle(1:fft_size/2+1));


% (***Part -3***)
% Concatenate the Mirror image of 'P'            
P = [P; conj(flipud(P(2:end-1)))];

% figure, plot(imag(ifft(P, fft_size)))
% pause,
% (***Part -4***)
% Perform IFFT and include the scale factor 'fft_size' to undo the 
% amplitude normalization during step-1
Synth_audio = real(ifft(P, fft_size)) * fft_size;
