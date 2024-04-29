
close all;

fs=32000;		% Frec de muestreo (Hz)
kf= 800; 		% Cte de desviacion de frec (Hz/V)
fc=3000; 		% Frec de portadora (Hz)
fm= 200; 		% Frec moduladora (Hz);, modifica que tan separadas estas las componentes en la representación de la DEP

N=100000; 		% Number of samples

n=0:N-1;
Ts=1/fs;
t=n*Ts; 		% Sampling times

m=sin(2*pi*fm*t); % Modulating signal, señal moduladora
xfm=cos(2*pi*fc*t+2*pi*kf*cumsum(m)*Ts); % FM signal

figure(1);
nn=1:500;
subplot(211),plot(t(nn),m(nn));
subplot(212),plot(t(nn),xfm(nn));

figure(2);
powerspec(xfm,Ts);

% EN FM, Beta =kf/fm
% TENGO UNA FOTO DE COMO CALCULAR LA POTENCIA MEDIA DE LAS COMPONENTES
% SELECCIONADAS
beta=kf*max(abs(m))/fm;
% SIENDO BETA =1, HAY 4 ORDENES, EL DE J(0),J(1),J(2) Y J(3)
sxp=1/4*(besselj(0,beta))^2;


