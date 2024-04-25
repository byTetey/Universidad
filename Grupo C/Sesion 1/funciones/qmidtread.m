function [y e pe pesc peg]=qmidtread(x,xsc,n)

%Entradas:
% x: vector con los valores a cuantificar
% xsc: valor de sobrecarga del cuantificador
% n: número de bits del cuantificador

%Salidas:
%  y : muestras cuantificadas
%  e:  error o ruido de cuantificación
%  pe: potencia del ruido de cuantificación
%  pesc: potencia de error de sobrecarga
%  peg: potencia de error granular

% Autor: Eduardo Rodríguez Banga. Universidade de Vigo. 

L=2^n-1; % Precindimos de un escalón para poder considera el cuantificador simétrico.
delta=2*xsc/L;

ax=abs(x);

y=round(ax/delta)*delta;

ind=find(ax>=xsc);  % Si la entrada en valor absoluto es mayor que el valor de sobrecarga...
y(ind)=(L-1)/2*delta; % ... su salida corresponde a la del último intervalo.

y=y.*sign(x); %corregimos el signo.

e=x-y; %Error o ruido de cuantificación

isc=find(abs(e)>delta/2); % Índices de las muestras que originan error de sobrecarga.
ig=find(abs(e)<=delta/2); % Índices a las muestras que originan ruido granular


pe=sum(e.^2)/length(e);
pesc=sum(e(isc).^2)/length(e);
peg=sum(e(ig).^2)/length(e);

end

