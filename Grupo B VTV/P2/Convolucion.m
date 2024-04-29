function [y,ty] = Convolucion(x,tx,h,th)
% 
% Convolucion de senhales analogicas finitas.
%
% Uso [y,ty] = Convolucion(x,tx,h,th);
% x,tx .- primera senhal a convolucionar (valores y base de tiempos).
% h,th .- segunda senhal a convolucionar (valores y base de tiempos).
% y,ty .- resultado (valores y base de tiempos).
% Si las bases de tiempos de las entradas no tienen el mismo incremento.
% el resultado sera vacio (y = []; ty = []).
%
Dy = delta(tx); % Periodo de muestreo del resultado
if (Dy==-1)||(abs(Dy-delta(th))>Dy/10)
    % No es posible hacer convolucion,
    % diferentes periodos de muestreo
    % o muestreo no uniforme.
    fprintf(2,'Las bases de tiempos son incoherentes.\n');
    y = [];
    ty = [];
    return;
end
if (length(x)~=length(tx))
    % Vectores de longitud diferente en la senhal x.
    fprintf(2,'La senhal x tiene un vector de valores de longitud distinta a su base de tiempos.\n');
    y = [];
    ty = [];
    return;
end
if (length(h)~=length(th))
    % Vectores de longitud diferente en la senhal h.
    fprintf(2,'La senhal h tiene un vector de valores de longitud distinta a su base de tiempos.\n');
    y = [];
    ty = [];
    return;
end
ty0 = min(tx)+min(th); % Tiempo inicial del resultado
Ny = length(tx)+length(th)-1; % Numero de muestras del resultado
ty1 = ty0 + (Ny-1)*Dy; % Tiempo final del resultado
ty = ty0:Dy:ty1; % Base de tiempos del resultado
y = conv(x,h)*Dy; % Valores (que nos da la convolucion discreta), ojo a la normalizacion
