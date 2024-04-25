pause on;
pause off;

[s,fs]=audioread('paulo8khz.wav');
seg1=s(4600:4850);
%Es conveniente enventanar con una ventana Hamming

window=hamming(length(seg1));
window=window/sum(window);  % caso omiso
seg1=seg1.*window;
[Hseg1,w]=freqz(seg1,1,1024); %Podr�a haber empleado fft.

subplot;
plot(0:length(seg1)-1,seg1);


[ak Pp]=lpc(seg1,10);  % p=10 es usual en codificaci�n de voz

%Pp no es exactamente la energ�a del error de predicci�n, sino su
% potencia (varianza). Entonces es necesario estimar Ep

Ep=Pp*length(seg1);

% El filtro de predicci�n lineal debe tener una ganancia G=sqrt(Ep)
% para que su energ�a sea la misma que la de seg1.

% La excitaci�n, la secuencia de error de predicci�n, se puede obtener por filtrado inverso

exc1=filter(ak,sqrt(Ep),seg1);

%Calculemos b el coeficiente del predictor largo.
% De cualquier estimaci�n previa del periodo sabemos que est� en torno a
% 80. Busquemos en el intervalo (70,90)

Emin=exc1'*exc1; %Inicializaci�n del error 
P=1; % Inicializaci�n del periodo
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

%El predictor largo (an�lisis) ser� un filtro FIR de coeficientes

c=[1 zeros(1,P-1) bmin];        % P = T = distancia entre muestras

%Si hacemos pasar la se�al exc1 por el filtro inverso del predictor largo (an�lisis)

res=filter(c,1,exc1);


subplot(211),plot(exc1);
subplot(212),plot(res);
pause;

%Se observa que poco se ha reducido la periodicidad. 
% Esto se debe en parte a que la periodicidad de la se�al de voz, considerada como 
%una se�al continua, no tiene por qu� coincidir con un n�mero exacto de
%muestras. 
%La utilizaci�n de periodos con precisi�n de fracciones de muestrea mejora
%ostensiblemente las prestaciones.
%El predictor largo se puede utilizar para introducir periodicidad
%en una secuencia de ruido blanco.





