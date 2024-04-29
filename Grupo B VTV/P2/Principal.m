close all;
longitud = 3000;
Ts = 1;
rate = 10;
T0 = Ts/rate; % Período de muestreo
bitstream = CreaSecuencia(longitud); % Se crea la secuencia de bits
SymbolStream = CodificaSecuencia(bitstream); % Codificamos los bits
Tmin = rate;
Tmax = (length(SymbolStream)-1)*Ts;
[s,t] = PasarAnalogico(SymbolStream,T0,rate); % Sin ruido
DibujarConstelacion(s,t,Ts,T0,Tmin,Tmax);
DiagramaOjo(s,t,Ts,rate,Tmin,Tmax,0); 
desviacion_ruido = 0.02;
[sr,tr] = SumarRuido(s,t,desviacion_ruido); % Se añade ruido a la señal
DibujarConstelacion(sr,tr,Ts,T0,Tmin,Tmax);
DiagramaOjo(sr,tr,Ts,rate,Tmin,Tmax,0);