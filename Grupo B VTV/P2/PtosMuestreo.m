function Indexes = PtosMuestreo(btiempos,Ts,T0,Tmin,Tmax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
% Encuentra los puntos de muestreo. %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = length(btiempos); % Longitud de la base de tiempos
umbral = 0.00001; % Umbral para los redondeos (por debajo suponemos cero)
cont = 1; % Para contar cuantos hemos encontrado
Tmin = Tmin - T0/2;
Tmax = Tmax + T0/2; % Para evitar redondeos
for i=1:L,
    tiempo = btiempos(i);
    if (tiempo<Tmin)
        continue;
    end
    if (tiempo>Tmax)
        continue;
    end
    aux = round(tiempo/Ts);
    resto = abs(tiempo-aux*Ts); % Calcular el "resto" de dividir por Ts
    if (resto<umbral)
        % Este indice vale ==> apuntarlo
        Indexes(cont) = i;
        cont = cont + 1;
    end
end
        