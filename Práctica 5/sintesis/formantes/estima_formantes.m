
[speech,fs]=audioread('paulo8khz.wav');
speech=reshape(speech,1,length(speech));

N=281; window_shift=160;

window=hamming(N)';

number_of_frames=floor(length(speech)/window_shift);
[F B m]=formantes(speech,[1:number_of_frames],window, window_shift);


plot(m,F(:,1),'b.',m,F(:,2),'r.',m,F(:,3),'g.',m,F(:,4),'y.');




