function [ZCR m]=stZCR(speech,frame_index,window,window_shift)

N=length(window);

ZCR=[];
m=[];
for i=1:length(frame_index)


    ini_sample=(i-1)*window_shift+1;
    end_sample=ini_sample+N-1;
    if (end_sample<=length(speech))
        
        segment=speech(ini_sample:end_sample);
        s1=sign(segment);
        diffsig=abs([s1 0]-[0 s1]);
        ZCR=[ZCR floor(sum(diffsig)/2)];

        m=[m end_sample];
    end    

end

ZCR=ZCR/N;