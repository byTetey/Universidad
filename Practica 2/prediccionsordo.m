pause on;
pause off;

n=randn(1,10000);% Ruido blanco
n=n/sqrt(n*n'); % Normalización de energía
den=[1 -0.5 +0.3 -0.5 0.4]; %coeficientes del denominador de un filtro IIR
num=1; %numerador del filtro IIR

s=filter(num,den,n); %calculamos la salida del filtro
% n es la señal que se desea filtrar
subplot(211),plot(n),title('Ruido blanco');
subplot(212),plot(s),title('Ruido filtrado');

pause;

p=2 % Orden de predicción

%Es conveniente que mires la ayuda de la función lpc.
[ak Pp]=lpc(s,p); % Vector LPC, comenzando con el 1 del predictor.
% Pp: potenida del error de prediccion. Pp no es exactamente la energía del error de predicción, sino su
% potencia (varianza) IMPORTANTE
[Hf,w]=freqz(num,den,1024); %Respuesta en frecuencia del filtro exacto, del orginal
[Ha,w]=freqz(sqrt(Pp*length(s)),ak,1024); %Respuesta en frecuencia del filtro de predicción lineal.
% cada par de polos ocasionados produce 1 resonancia.
subplot;
plot(w,20*log10(abs(Hf)),'b',w,20*log10(abs(Ha)),'r')
title('Filtro original(azul) y filtro LPC (rojo) con p=2'); 
xlabel('rad'), ylabel ('dB');
pause;

%Repetimos para un orden de predicción 4 

p=4 % Orden de predicción

[ak Pp]=lpc(s,p); % Vector LPC, comenzando con el 1 del predictor.

[Hs,w]=freqz(s,1,1024); %Respuesta en frecuencia de s(n)
                       %Se podría haber hecho con la función fft.
[Hf,w]=freqz(num,den,1024); %Respuesta en frecuencia del filtro
[Ha,w]=freqz(sqrt(Pp*length(s)),ak,1024); %Respuesta en frecuencia del filtro de predicción lineal.

subplot;
plot(w,20*log10(abs(Hf)),'b',w,20*log10(abs(Ha)),'r');
title('Filtro original(azul) y filtro LPC (rojo) con p=4'); 
xlabel('rad'), ylabel ('dB');
pause;

% Consideremos ahora un segmento sordo de voz, que como
% sabemos se suele modelar como la respuesta de un filtro 
% a una excitación de ruido blanco.

[s,fs]=audioread('paulo8khz.wav');
seg1=s(7000:7250).*hamming(251);
[Hseg1,w]=freqz(seg1,1,1024); %Podría haber empleado fft.

subplot;
plot(0:length(seg1)-1,seg1),title('Señal de voz');


[ak Pp]=lpc(seg1,10);  % p=10 es usual en codificación de voz

%Pp no es exactamente la energía del error de predicción, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicción lineal debe tener una ganancia G=sqrt(Ep)
% para que su energía sea la misma que la de seg1.

[Ha,w]=freqz(sqrt(Ep),ak,1024);

subplot;
plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Ha)));
title('Espectro de un segmento sordo y su envolvente LPC, p=10');
pause;
%Vemos que la envolvente espectral se aproxima razonablemente bien, aunque
%mejorará aumentando el orden de predicción .Consideremos p=14

[ak Pp]=lpc(seg1,14);  % p=10 es usual en codificación de voz

%Pp no es exactamente la energía del error de predicción, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicción lineal debe tener una ganancia G=sqrt(Ep)
% para que su energía sea la misma que la de seg1.

[Ha,w]=freqz(sqrt(Ep),ak,1024);

subplot;
plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Ha)));
title('Espectro de un segmento sordo y su envolvente LPC, p=14');
pause;
%Por tanto, en principio cuanto mayor sea el orden de predicción, mejor.
%Sin embargo los codificadores de voz tratan de transmitir la menor
%cantidad de parámetros posible, lo que en la práctica obliga a que el
%número de coeficientes sea habitualmente 10 o 12.


% Si ahora filtramos el segmento de voz por el inverso del filtro de
% predicción, obtendremos la señal de excitación que daría lugar a ese
% segmento de voz al pasarlo por el filtro LPC.


%Como el filtrado inverso habrá eliminado parte de la correlación entre
%muestras de la señal de voz, el espectro de la señal de excitación debería
%ser más plano (más blanco). 

[ak Pp]=lpc(seg1,14);
Ep=Pp*length(seg1);

exc1=filter(ak,sqrt(Ep),seg1);
[Hexc1,w]=freqz(exc1,1,1024);


plot(w,20*log10(abs(Hseg1)),'b',w,20*log10(abs(Hexc1)),'r');
title('Espectro del segmento sordo (azul) y error de predicción (rojo)');
pause;

%Planteándolo de otra forma. Si el filtro LPC contiene la mayor parte de la
%información de correlación entre muestras de la señal de voz, si paso una
%señal de ruido blanco (incorrelado) debe obtener una señal parecida al
%segmento analizado.

n=randn(1,251);% Ruido blanco
%n=n/sqrt(n*n'); % Normalización de energía

sint1=filter(sqrt(Ep),ak,n);

subplot(211),plot(seg1);
subplot(212),plot(sint1);
pause;

%Aunque son segmentos muy cortos, escuchándolos se puede 
%observar su parecido

soundsc(seg1); pause; soundsc(sint1);

%Observemos sus espectros. Veremos que hay cierto, sobre todo en la energía
%contenida en cada banda de frecuencia, aunque no tanto en su estructura
%fina, que depende enormemente de la secuencia de ruido generada.
% No obstante este modelo es bastante adecuado para sonidos sordos.

[Hsint1,w]=freqz(sint1.*hamming(length(sint1))',1,1024);


subplot(211), plot(w,20*log10(abs(Hseg1))); title('Espectro segmento sordo');
subplot(212),plot(w,20*log10(abs(Hsint1))); title('Espectro segmento sintético');

%**************************************************************************
%**************************************************************************


