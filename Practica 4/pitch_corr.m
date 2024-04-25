function [f0, voiced]=pitch_corr(speech_frame,fs);

 N=length(speech_frame);
 speech_corr=xcorr(speech_frame,speech_frame);
 
 search_limit=floor((length(speech_corr)-1)/2-20);
 
 [p0,p0_index]=max(speech_corr);
 [p1,p1_index]=max(speech_corr(1:search_limit));
 
 voiced=(p1/p0>0.3);

 if(voiced)
     pitch_period=p0_index-p1_index;
     f0=fs/pitch_period;
 else
     f0=0;
 end
 

 
 