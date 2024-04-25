pause on;
pause off;

%Repitamos el análisis para un sonido sonoro

[s,fs]=audioread('paulo8khz.wav');
seg1=s(21600:21850);
%Es conveniente enventanar con una ventana Hamming

w=hamming(length(seg1));

seg1=seg1.*w;
[Hseg1,w]=freqz(seg1,1,1024); %Podría haber empleado fft.

subplot;
plot(0:length(seg1)-1,seg1);
pause;


[ak Pp]=lpc(seg1,10);  % p=10 es usual en codificación de voz

%Pp no es exactamente la energía del error de predicción, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicción lineal debe tener una ganancia G=sqrt(Ep)
% para que su energía sea la misma que la de seg1.

[Ha,w]=freqz(sqrt(Ep),ak,1024);

subplot;
plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Ha)));
pause;

%Vemos que la envolvente espectral se aproxima razonablemente bien, aunque
%en general mejorará aumentando el orden de predicción .Consideremos p=14

[ak Pp]=lpc(seg1,14);  % p=10 es usual en codificación de voz

%Pp no es exactamente la energía del error de predicción, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicción lineal debe tener una ganancia G=sqrt(Ep)
% para que su energía sea la misma que la de seg1.

[Ha,w]=freqz(sqrt(Ep),ak,1024);
5
subplot;
plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Ha)));
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

%Aquí se observa este efecto claramente, aunque permanece la estructura
%armónica en la señal de excitación

plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Hexc1)));
pause;
% HABIENDO PASADO LA VOZ A 1/A(Z) SE MANTIENEN LOS ARMÓNICOS PERO SE PIERDE
%LA ENVOLVENTE
% Que quede estrcutura armónica en la señal de excitación implica que hay
% periodicidad en la excitación o , dicho de otra forma, que no hemos
% blanqueado lo suficiente la señal de voz.

%Una prueba muy sencilla consiste en representar y escuchar las formas de
%onda de la señal de voz y de excitación.

subplot(211),plot(seg1);
subplot(212),plot(exc1);
pause;
soundsc(seg1),pause;soundsc(exc1);
pause;

%Consideremos ahora un nivel de predicción muy elevado que sea capaz de
%modelar la periodicidad de la señal de voz, p=90.

[ak Pp]=lpc(seg1,80);
Ep=Pp*length(seg1);

%Representemos en primer lugar el espectro del segmento de voz
%y el del filtro LPC.

[Ha,w]=freqz(sqrt(Ep),ak,1024);

subplot;
plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Ha)));
pause;
% PARA p mucho mas grandes: ahora no se asemeja a una envolvente, se pasa a
% modelar cada uno de los armonicos, no el tracto vocal

%Ahora se modela mucho mejor la estructura armónica de la voz sonora.

%Su espectro va a ser claramente más plano (blanco), lo que implica la
%eliminación de la periodicidad en gran medida

exc2=filter(ak,sqrt(Ep),seg1);
[Hexc2,w]=freqz(exc2,1,1024);

plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Hexc2)));
pause;
% SI USAMOS UNA P MUY GRANDE SERÍA CAPAZ DE INTRODUCIR PERIODICIDAD (ESO A 1/A(Z)), SI LA SALIDA ESTA ENTRA A A(Z) SE ASEMEJA A RUIDO BLANCO

%No obstante aumentar enormemente el número de LPCs que hay que codificar
%no es posible en codificación de voz. La alternativa es considerar un
%orden de 10 o 12 y utilizar durante los sonidos sonoros una señal de
%excitación que sea periódica con el periodo fundamental del segmento de
%voz. En su forma más sencilla un tren de deltas.

% En el segmento que nos ocupa la periodicidad es aprox. 80 muestras.
%Generemos un sonido largo sostenido y p=10


[ak Pp]=lpc(seg1,10);       % CON P=10 EL FILTRO VULELVE A MODELAR EL TRACTO VOCAL
Ep=Pp*length(seg1);

u=[1 zeros(1,79)];
e1=[u u u u u u u u u u u u u u u u u ];


sint1=filter(sqrt(Ep),ak,e1);

subplot(211),plot(seg1);
subplot(212),plot(sint1(1:length(seg1)));
pause;
% CIERTA PERIODICIDAD ENTRE EL SEGMENTO SINTETICO Y EL TROZO SIN ENVENTANAR
% DEL PRINCIPIO s(21600:21850)
%Escuchemos seg1 y sint1

soundsc(seg1); pause; soundsc(sint1);



