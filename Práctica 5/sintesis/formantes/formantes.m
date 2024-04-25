function [F B m]=formantes(speech,frame_index,window,window_shift)

N=length(window);

F=[];
B=[];
m=[];
for i=1:length(frame_index)

    i
    ini_sample=(i-1)*window_shift+1;
    end_sample=ini_sample+N-1;
    if (end_sample<=length(speech))
        
        segment=speech(ini_sample:end_sample).*window;
        [ff,bw]=lpc2formant(lpc(segment,10));
       
        temp1=zeros(1,5);
        temp2=zeros(1,5);
        
        temp1(1:length(ff))=ff;
        temp2(1:length(ff))=bw;
        
        F=[F; temp1];
        B=[B; temp2];

        m=[m end_sample];
    end    

end