
close all;

[s fss]=audioread('radio3.wav');
s=reshape(s,1,length(s));           % construimos un vector columna, los valores uno detras de otro
s=s/max(abs(s));                        % normalizamos los valores con el maximo
sound(s,fss);
m=interp(s,80);                         % interpolamos por 80, multil. por 80 el numero de muestras



fs=fss*80;  	% Sampling frequency (Hz)       % cambimaos la frec de muestreo
kf=200e3; 		% Cte de desviacion de frec (Hz/V) (tmb llamada sensibilidad de frec.)
fc=100e3; 		% Carrier frequency (Hz)

N=length(m); 	% Number of samples
nfft=N; 		% Number of points of the FFT
df=fs/nfft; 	% Spectral resolution

n=0:N-1;
Ts=1/fs;
t=n*Ts; 		% Instantes de muestreo

%FM signal
xfm=cos(2*pi*fc*t+2*pi*kf*cumsum(m)*Ts); 


figure(1)
powerspec(xfm,1/fs);

W=4e3;              % ancho de banda de la señal moduladora
D=kf*max(abs(m))/W;         %25*1/4=6
BFm=2*(D+1)*W;              %14*4=56Hz de ancho de banda
