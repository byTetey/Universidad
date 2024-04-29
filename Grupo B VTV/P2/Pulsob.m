function [p,tp] = Pulsob(rate,Ts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% Crea un pulso conformador  %
% (coseno alzado).           %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rolloff = 0.5; % Factor de rolloff
Nlob = 3; % Numero de lobulos
p0 = rcosdesign(rolloff,2*Nlob,rate,'normal'); % Valores del pulso
p = p0/max(p0);
L = length(p); % Longitud
n = 0:L-1; % Base de tiempos discreta
nc = (L-1)/2; % Valor central
n1 = n-nc; % Base de tiempos discreta y centrada
tp = n1*(Ts/rate); % Base de tiempos continua
