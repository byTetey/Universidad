function [speech_frame,ori_signal]=frame(speech,frame_index,window_shift,window);

ini_sample=(frame_index-1)*window_shift+1
end_sample=ini_sample+length(window)-1

if(end_sample<length(speech))
    s=speech(ini_sample:end_sample);
else
    s=[speech(ini_sample:length(speech)) zeros(1,end_sample-length(speech))];
end

ori_signal=s;
speech_frame=s.*window;

    



