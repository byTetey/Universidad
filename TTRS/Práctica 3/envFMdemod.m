
close all

[s fss]=audioread('radio3.wav');
s=reshape(s,1,length(s));
s=s/max(abs(s));


M=80 		% Interpolation factor 
m=interp(s,M);  
% Apartado b cuestión 4
VN=0.06; 		% Varianza del ruido

fs=fss*M;  	% Sampling frequency (Hz)
kf=100e3; 	% Cte de desviacion de frec (Hz/V) (tmb llamada sensibilidad de frec.)
fc=100e3; 	% Carrier frequency (Hz)

N=length(m); % Number of samples

n=0:N-1;
Ts=1/fs;
t=n*Ts; 	% Sampling times


% FM signal
xfm=cos(2*pi*fc*t+2*pi*kf*cumsum(m)*Ts)+sqrt(VN)*randn(1,length(t)); % señal modulada

figure(1)
powerspec(xfm,1/fs);

% Receptor

xlim=limiter(xfm,0.9);      % el limitador limpia la señal de posibles distorsiones de amplitud
% basicamente recorta la señal si ésta supera x valor
% al recortar mas la señal, i.e, disminuir el valor se mitiga el ruido
dx=diff(xlim);      % derivamos
rdx=abs(dx);        % rectificaicon de onda completa, por lo que nos quedamos con los valores positi.

L=400;
h=firpm(L,[0 3600 4000 fs/2]/(fs/2),[1 1 0 0]);
xbb=filter(h,1,rdx);
xbb=xbb(L/2+1:end);   % elimina las componentes iniciales de la salida del filtro
xbb=xbb-mean(xbb);      % elimina las componentes de continua


vd=decimate(xbb,M);     % diezamamos, i.e, deshacemos la interpolacion

sound(vd,fs/M);

figure(2);
powerspec(vd,M/fs);




