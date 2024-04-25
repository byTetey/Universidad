% Script adapted from the example at https://www.ee.columbia.edu/~dpwe/resources/matlab/dtw/ 
  addpath('./voicebox');

% Load two speech waveforms of the same digit
 [d1,fs] = audioread('audio/digitos/siete01.wav');
 [d2,fs] = audioread('audio/digitos/siete02.wav');
 
 % Listen to them together:
 ml = min(length(d1),length(d2));
 %soundsc(d1(1:ml)+d2(1:ml),fs);
 % or, in stereo
 soundsc([d1(1:ml),d2(1:ml)],fs);
 
 % calculate mel cepstrum with 12 coefs, 256 sample frames, no overlap.
 D1 = melcepst(d1,fs)';   
 D2 = melcepst(d2,fs)'; 
 
 figure(1);
 subplot(211),specgram(d1,2048,fs,512,384);
 subplot(212),specgram(d2,2048,fs,512,384);
 

 % Look at it:
 figure(2);
 
 subplot(211);
 surf(1:size(D1,2),1:size(D1,1),D1);
 view(0,90);
 axis([1 size(D1,2) 1 12]);
 %colormap(flipud(gray));
 colorbar;
 
 subplot(212);
 surf(1:size(D2,2),1:size(D2,1),D2);
 view(0,90);
 axis([1 size(D2,2) 1 12]);
 %colormap(flipud(gray));
 colorbar;
 

 SM = simmx(D1,D2);
 
 % Look at it:
 figure(3);
 surf(1:size(SM,2),1:size(SM,1),SM);
 axis xy;
 ylabel('D1'); xlabel('D2');
 view(0,90);
 colormap(flipud(gray));
 colorbar;

 
 % You can see a dark stripe (high similarity values) approximately
 % up the leading diagonal.
 
 
 % Use dynamic programming to find the lowest-cost path between the 
 % opposite corners of the cost matrix
 % Note that we use 1-SM because dp will find the *lowest* total cost
 [p,q,C] = dp(1-SM);
 % Overlay the path on the local similarity matrix
 figure(4)

 imagesc(SM)
 colormap(flipud(gray))
 axis xy;
 colorbar;
 hold on; plot(q,p,'r'); hold off
 % Path visibly follows the dark stripe
 
 
 % Bottom right corner of C gives cost of minimum-cost alignment of the two
 C(size(C,1),size(C,2))


 
 
 
 