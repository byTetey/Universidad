function [y e pe pesc peg]=qmidriser(x,xsc,n)

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

L=2^n;
delta=2*xsc/L;

ax=abs(x);
k=floor(ax/delta); % Puede tomar los valores 0,1,...,L/2-1
ind=find(k>L/2-1); % índices a las muestras en los intervalos de los extremos. 
k(ind)=L/2-1; % El valor de k no puede ser mayor que L/2-1
y=k*delta+delta/2; 
y=y.*sign(x); %Tenemos en cuenta el signo

e=x-y; %Error o ruido de cuantificación

isc=find(abs(x)>xsc); % índices de las muestras que origina error de sobrecarga.
ig=find(abs(x)<=xsc); % índices a las muestras que originan ruido granular

pe=sum(e.^2)/length(e);
pesc=sum(e(isc).^2)/length(e);
peg=sum(e(ig).^2)/length(e);

end

