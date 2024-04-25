close all;
pause off;
% Leemos la señal de voz, la frecuencia de muestreo
% y el número de bits por muestra.

[s,fs]=audioread('paulo8khz.wav');

%Eje temporal
time=(0:length(s)-1)/fs;
plot(time,s);
pause;

%Representamos la forma de onda de un claro ejemplo de
%sonido sonoro.

plot(time(4000:5000),s(4000:5000));axis tight;
pause;


% Normalmente es más sencillo utilizar el índice "n" como
% eje x

n=0:length(s)-1;
plot(n(4000:5000),s(4000:5000));axis tight;
pause;


%Representamos un segmento del sonido sonoro
%seg1=s(4400:4800);
seg1=s(4400:4650);
%plot(n(4400:4650),seg1);axis tight;
plot(n(4400:4650),seg1);axis tight;
pause;


% Con una ventana hamming la parte central del segmento
% tiene mayor relevancia.

window=hamming(length(seg1));
wseg1=seg1.*window;         
%plot(n(4400:4650),seg1);axis tight;
plot(n(4400:4650),seg1);axis tight;
pause;

%Calculamos y visualizamos el módulo del espectro.

fseg1=fft(wseg1,1024); %FFT de 1024 muestras entre 0 y 2pi
                    
% Solamente consideraremos las frecuencias discretas entre 0 y pi                    
modfseg1=abs(fseg1(1:1024/2+1));

%Eje de frecuencia en Hz.

fHz=0:fs/1024:fs/2;

subplot(211),plot(n(4400:4650),seg1);axis tight;        % seg1 es la mueestra sin enventanar
subplot(212),plot(fHz,modfseg1);
pause;

% Normalmente el módulo se representa en escala logarítmica para ver mejor
% las amplitudes pequeñas

subplot(211),plot(n(4400:4650),seg1);axis tight;
subplot(212),plot(fHz,20*log10(modfseg1));
pause;

%*************************************************************
% EJERCICIO: ¿Qué información se puede obtener de la representación previa?
%*******************************************************************

% Consideraremos ahora un segmento muy pequeño de la parte central de seg1.
% la frecuencia fundamental es el primer pico, no el mas alto.
seg2=seg1(100:135);     % vamos a coger las muestras entre 100 y 135
window2=hamming(length(seg2));
wseg2=seg2.*window2;
fseg2=fft(wseg2,1024);
modfseg2=abs(fseg2(1:1024/2+1));

subplot(212),plot(fHz,20*log10(modfseg1),fHz,20*log10(modfseg2));
% en mosfseg1 hay 251 muestras por lo que no hay la misma energia que en
% una de 36
% Para la representación compensaremos la diferencia de energía entre seg1
% y seg2

energy1=seg1'*seg1;
energy2=seg2'*seg2;
GdB=20*log10(energy1/energy2);

subplot(212),plot(fHz,20*log10(modfseg1),fHz,20*log10(modfseg2)+GdB);

pause;


%*************************************************************
% EJERCICIO: ¿Qué observas en la figura previa?
%*******************************************************************


%*************************************************************
% EJERCICIO: Repite todos los pasos previos utilizando ahora una
% ventana rectangular. Guarda las figuras y describe los efectos
% que observas.
%*******************************************************************
% no se usa la ventana rectangular para las representaciones ya que los
% lobulos secundarios tienen mucha altura


