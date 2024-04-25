% Script adapted from the example at https://www.ee.columbia.edu/~dpwe/resources/matlab/dtw/

% Load two speech waveforms of the same digit
 [d1,fs] = audioread('audio/digitos/siete01.wav');
 [d2,fs] = audioread('audio/digitos/siete02.wav');
 
 % Listen to them together:
 ml = min(length(d1),length(d2));
 %soundsc(d1(1:ml)+d2(1:ml),fs);
 % or, in stereo
 soundsc([d1(1:ml),d2(1:ml)],fs);
 
 % Calculate STFT features for both sounds (25% window overlap)
 D1 = specgram(d1,512,fs,512,384);
 D2 = specgram(d2,512,fs,512,384);
 
 figure(1);
 subplot(211),specgram(d1,2048,fs,512,384);
 subplot(212),specgram(d2,2048,fs,512,384);
 
 % Construct the 'local match' scores matrix as the cosine distance 
 % between the STFT magnitudes (the higher score, the more similar vectors)
 SM = simmx(abs(D1),abs(D2));   % MAYOR VALOR, MAS PARECIDAS SON d1 y d2
 
 
 % Look at it:
 figure(2);
 subplot;
 surf(1:size(SM,2),1:size(SM,1),SM);
 ylabel('D1'); xlabel('D2');
 axis xy;
 view(0,90);
 colormap(flipud(gray));
 F=getframe;

 
 % You can see a dark stripe (high similarity values) approximately
 % up the leading diagonal.
 
 
 % Use dynamic programming to find the lowest-cost path between the 
 % opposite corners of the cost matrix
 % Note that we use 1-SM because dp will find the *lowest* total cost
 [p,q,C] = dp2(1-SM);
 % Overlay the path on the local similarity matrix
 figure(3)

 imagesc(SM)
 axis xy;
 colormap(flipud(gray))
 hold on; plot(q,p,'r'); hold off
 % Path visibly follows the dark stripe
 
 
 % Bottom right corner of C gives cost of minimum-cost alignment of the two
 C(size(C,1),size(C,2))


 
 
 
 