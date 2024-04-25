

fs=8000; %frecuencia de muestreo

%Ahora generamos el ruido pasobanda con ancho de banda el 
%de la banda crítica centrada en 410 Hz.

n=randn(1,30000);
b=fir1(600,[410-45 410+45]/(fs/2));
nb=filter(b,1,n);

% Estimamos la potencia del ruido pasobanda
Pnb=(nb*nb')/length(nb);

% Estimamos la amplitud de una sinusoide de forma
% que su potencia sea 4 dB inferior a la del ruido.

Amin=sqrt(2*Pnb/10^0.4);

%Generamos el tono de 410 Hz con la amplitud estimada
tono=Amin*cos(2*pi*480*(1:30000)/fs);


 sound(nb,fs);
sound(tono,fs);
sound(tono+nb,fs);
% Y si en lugar de 410 Hz usamos un tono de 480?


