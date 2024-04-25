pause on;
pause off;

%Repitamos el an�lisis para un sonido sonoro

[s,fs]=audioread('paulo8khz.wav');
seg1=s(21600:21850);
%Es conveniente enventanar con una ventana Hamming

w=hamming(length(seg1));

seg1=seg1.*w;
[Hseg1,w]=freqz(seg1,1,1024); %Podr�a haber empleado fft.

subplot;
plot(0:length(seg1)-1,seg1);
pause;


[ak Pp]=lpc(seg1,10);  % p=10 es usual en codificaci�n de voz

%Pp no es exactamente la energ�a del error de predicci�n, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicci�n lineal debe tener una ganancia G=sqrt(Ep)
% para que su energ�a sea la misma que la de seg1.

[Ha,w]=freqz(sqrt(Ep),ak,1024);

subplot;
plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Ha)));
pause;

%Vemos que la envolvente espectral se aproxima razonablemente bien, aunque
%en general mejorar� aumentando el orden de predicci�n .Consideremos p=14

[ak Pp]=lpc(seg1,14);  % p=10 es usual en codificaci�n de voz

%Pp no es exactamente la energ�a del error de predicci�n, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicci�n lineal debe tener una ganancia G=sqrt(Ep)
% para que su energ�a sea la misma que la de seg1.

[Ha,w]=freqz(sqrt(Ep),ak,1024);
5
subplot;
plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Ha)));
pause;

%Por tanto, en principio cuanto mayor sea el orden de predicci�n, mejor.
%Sin embargo los codificadores de voz tratan de transmitir la menor
%cantidad de par�metros posible, lo que en la pr�ctica obliga a que el
%n�mero de coeficientes sea habitualmente 10 o 12.


% Si ahora filtramos el segmento de voz por el inverso del filtro de
% predicci�n, obtendremos la se�al de excitaci�n que dar�a lugar a ese
% segmento de voz al pasarlo por el filtro LPC.

%Como el filtrado inverso habr� eliminado parte de la correlaci�n entre
%muestras de la se�al de voz, el espectro de la se�al de excitaci�n deber�a
%ser m�s plano (m�s blanco). 

[ak Pp]=lpc(seg1,14);
Ep=Pp*length(seg1);

exc1=filter(ak,sqrt(Ep),seg1);
[Hexc1,w]=freqz(exc1,1,1024);

%Aqu� se observa este efecto claramente, aunque permanece la estructura
%arm�nica en la se�al de excitaci�n

plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Hexc1)));
pause;
% HABIENDO PASADO LA VOZ A 1/A(Z) SE MANTIENEN LOS ARM�NICOS PERO SE PIERDE
%LA ENVOLVENTE
% Que quede estrcutura arm�nica en la se�al de excitaci�n implica que hay
% periodicidad en la excitaci�n o , dicho de otra forma, que no hemos
% blanqueado lo suficiente la se�al de voz.

%Una prueba muy sencilla consiste en representar y escuchar las formas de
%onda de la se�al de voz y de excitaci�n.

subplot(211),plot(seg1);
subplot(212),plot(exc1);
pause;
soundsc(seg1),pause;soundsc(exc1);
pause;

%Consideremos ahora un nivel de predicci�n muy elevado que sea capaz de
%modelar la periodicidad de la se�al de voz, p=90.

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

%Ahora se modela mucho mejor la estructura arm�nica de la voz sonora.

%Su espectro va a ser claramente m�s plano (blanco), lo que implica la
%eliminaci�n de la periodicidad en gran medida

exc2=filter(ak,sqrt(Ep),seg1);
[Hexc2,w]=freqz(exc2,1,1024);

plot(w,20*log10(abs(Hseg1)),w,20*log10(abs(Hexc2)));
pause;
% SI USAMOS UNA P MUY GRANDE SER�A CAPAZ DE INTRODUCIR PERIODICIDAD (ESO A 1/A(Z)), SI LA SALIDA ESTA ENTRA A A(Z) SE ASEMEJA A RUIDO BLANCO

%No obstante aumentar enormemente el n�mero de LPCs que hay que codificar
%no es posible en codificaci�n de voz. La alternativa es considerar un
%orden de 10 o 12 y utilizar durante los sonidos sonoros una se�al de
%excitaci�n que sea peri�dica con el periodo fundamental del segmento de
%voz. En su forma m�s sencilla un tren de deltas.

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



