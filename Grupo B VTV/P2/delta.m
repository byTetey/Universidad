function D = delta(btiempos)
% 
% Calcular el periodo de muestreo (incremento) de una base de tiempos.
%
% Uso D = delta(btiempos);
% D, periodo resultante.
% btiempos, variable que contiene la base de tiempos.
% Si el incremento no es constante el resultado es -1.
%
d = diff(btiempos); % Derivada primera
desv = std(d); % Desviacion estandar
med = mean(d); % Media
if (desv>0.1)
    % No parece un muestreo uniforme
    D = -1;
else
    % Este si
    D = med;
end
