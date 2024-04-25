pause on;
pause off;

[s,fs]=audioread('paulo8khz.wav');
seg1=s(4600:4850);
%Es conveniente enventanar con una ventana Hamming

window=hamming(length(seg1));
window=window/sum(window);  % caso omiso
seg1=seg1.*window;
[Hseg1,w]=freqz(seg1,1,1024); %Podría haber empleado fft.

subplot;
plot(0:length(seg1)-1,seg1);


[ak Pp]=lpc(seg1,10);  % p=10 es usual en codificación de voz

%Pp no es exactamente la energía del error de predicción, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicción lineal debe tener una ganancia G=sqrt(Ep)
% para que su energía sea la misma que la de seg1.

% La excitación, la secuencia de error de predicción, se puede obtener por filtrado inverso

exc1=filter(ak,sqrt(Ep),seg1);

%Calculemos b el coeficiente del predictor largo.
% De cualquier estimación previa del periodo sabemos que está en torno a
% 80. Busquemos en el intervalo (70,90)

Emin=exc1'*exc1; %Inicialización del error 
P=1; % Inicialización del periodo
seqE=[];
for T=22:114        % tiene su explicacion en onenote
    excT=[zeros(1,T),exc1(1:length(exc1)-T)'];      % se descartan las ulimas muestras
    b=-sum(exc1'.*excT)/(excT*excT');
    excpl=-b*excT;
    error=exc1'-excpl;      % original menos error
    E=error*error';
    seqE=[seqE E];
    if (E<Emin)
        Emin=E;
        P=T;
        bmin=b;
    end
    
  end    
    
subplot;
subplot(211),plot(exc1);
subplot(212),plot(22:114,seqE);

pause;

%El predictor largo (análisis) será un filtro FIR de coeficientes

c=[1 zeros(1,P-1) bmin];        % P = T = distancia entre muestras

%Si hacemos pasar la señal exc1 por el filtro inverso del predictor largo (análisis)

res=filter(c,1,exc1);


subplot(211),plot(exc1);
subplot(212),plot(res);
pause;

%Se observa que poco se ha reducido la periodicidad. 
% Esto se debe en parte a que la periodicidad de la señal de voz, considerada como 
%una señal continua, no tiene por qué coincidir con un número exacto de
%muestras. 
%La utilización de periodos con precisión de fracciones de muestrea mejora
%ostensiblemente las prestaciones.
%El predictor largo se puede utilizar para introducir periodicidad
%en una secuencia de ruido blanco.





