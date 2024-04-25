function [Ceps,m,segment]=stCeps(speech,frame_index,window,window_shift,orden_N)

N=length(window);

Ceps=[];
m=[];
segment=[];
for i=1:length(frame_index)

    i
    ini_sample=(i-1)*window_shift+1;
    end_sample=ini_sample+N-1;
    if (end_sample<=length(speech))
        
        segment=[segment; speech(ini_sample:end_sample).*window];
        Ceps=[Ceps; real(ifft(log(abs(fft(segment(i,:),1024))),orden_N))];  
        m=[m end_sample];
    end    

end