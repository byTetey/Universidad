function tone=playTone(freq,level)
% PLAYTONE
%  playTone(freq,level)
%  generates an 'audiometric' tone lasting 0.3628
%  seconds at specified freq and level (specified in
%  Hz and dB respectively.

fs=22050;
t=1:8000;
ramp=0:0.001:1;
amp=dB2amp(level);
tone=amp*sin(2*pi*(freq/fs)*t);
% ramp at start and end with linear ramp
tone(1:1001)=ramp.*tone(1:1001);
tone(7000:8000)=fliplr(ramp).*tone(7000:8000);
sound(tone,fs);
