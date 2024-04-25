function [frec,bw]=lpc2formant(coef)

%  Calcula las frecuencias de los formantes y sus anchos de banda.
%	coef: Coeficientes del analisis LPC: [1 -a1 -a2...-ap]

fs=8000;  %frecuencia de muestreo


%Insertar aquí las líneas de código necesarias


%Completar donde aparezcan ????

frec=????  %vector con frecuencias de los formantes
                        
bw=????; %vector con anchos de banda

% Quitando las frecuencias negativas:

mascara=frec>0;
frec=frec(mascara);
bw=bw(mascara);

% Ordenandolas de menor a mayor:

[valores,indices]=sort(frec);
frec=frec(indices);
bw=bw(indices);