function [L,f]=banco1_3(x,fs);

octFiltBank = octaveFilterBank('1/3 octave',...
            'SampleRate',fs,'FrequencyRange',[63,8000]);
%        f=round(getCenterFrequencies(octFiltBank));
f=[63 80 100 125 160 200 250 315 400 500];
f=[f f*10 6300 8000];
N=length(f);
Laux=zeros(length(x),N);
y = octFiltBank(x);
Laux = sum(y.^2,1)/length(y);
L=round(10*10*log10(Laux/4e-10))/10;
% Redondeo a la décima de decibelio.