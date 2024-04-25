function [Rxx m]=stRxx(speech,frame_index,window,window_shift)

N=length(window);

Rxx=[];
m=[];
for i=1:length(frame_index)


    ini_sample=(i-1)*window_shift+1;
    end_sample=ini_sample+N-1;
    if (end_sample<=length(speech))
        
        segment=speech(ini_sample:end_sample).*window;
        Rxx=[Rxx; xcorr(segment,segment)];

        m=[m end_sample];
    end    

end