
[speech,fs]=audioread('paulo8khz.wav');
speech=reshape(speech,1,length(speech));


%N=160; window_shift=80;

N=80; window_shift=40; %Otra opción de valores.


window=hamming(N)';

%window=ones(1,N);   % Ventana rectangular

number_of_frames=floor(length(speech)/window_shift);
[energy m]=stenergy(speech,1:number_of_frames,window, window_shift);



subplot(211),plot(1:length(speech),speech); axis tight;
subplot(212),plot(m,energy); axis tight;





