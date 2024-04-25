
[speech,fs]=audioread('paulo8khz.wav');
speech=reshape(speech,1,length(speech));

%N=160; window_shift=80;

N=80; window_shift=40;


speech=speech(3000:12000);


window=hamming(N)';


number_of_frames=floor(length(speech)/window_shift);
[ZCR m]=stZCR(speech,[1:number_of_frames],window, window_shift);

subplot(211),plot(speech);axis tight;
subplot(212),plot(m,ZCR);axis tight;




