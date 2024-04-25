function [VQ vDist] = bsVQ(data, nbits, epsilon, umbral, display)

% Salidas:
% VQ: Matriz con los centroides resultantes por filas. 
% vDist: vector con la evolución de la distorsión en la últimada llamada a
%        Kmeans.
%
% Entradas:
% data : matriz con vector de datos por fila.
% nbits: numero de bits del VQ deseado.
% epsilon: parametro para dividir cada centroide en 2 (ej: 0.025).
% umbral: umbral de parada en GLAvq1
% display: si vale 1 y la dimensión es 2 entonces representa una gráfica.
%
% Ejemplo: load traindata; [VQ MSE] = bsVQ(traindata,4,0.025,1e-3,1);
%
% Autor: Eduardo Rodríguez Banga. Universidade de Vigo

sdata=size(data);
N=sdata(1);
L=sdata(2);
M=2^nbits; 
% N=sdata(1);
% L=sdata(2);

if(N<M) error('Número de datos insuficiente');
end

if(display && (L==2)) display=1;
else display=0;
end

if (display)
    figure(1);
    clf;
    plot(data(:,1),data(:,2),'g.')
    hold on;
end

VQ=mean(data);
sVQ=size(VQ);
bits=1;

while(bits<=nbits)
    [VQ, vDist, ~]=Kmeans(data,bits,[VQ*(1+epsilon); VQ*(1-epsilon)],umbral,0);
    sVQ=size(VQ);
    bits=bits+1;
end
 
 if(display)
        plot(data(:,1),data(:,2),'g.')
        hold on;
        plot(VQ(:,1),VQ(:,2),'b*');
        hold off;
 end
end
