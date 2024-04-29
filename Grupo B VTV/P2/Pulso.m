function [p,tp] = Pulso(rate,Ts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% Crea un pulso conformador  %
% (coseno alzado).           %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rolloff = 0.5; % Factor de rolloff
Nlob = 3; % Numero de lobulos
p = rcosdesign(rolloff,Nlob,rate,'sqrt'); % Valores del pulso
p = p/sqrt(sum(p.^2)); % Normalizar el pulso para que la energía sea 1
L = length(p); % Longitud
n = 0:L-1; % Base de tiempos discreta
nc = (L-1)/2; % Valor central
n1 = n-nc; % Base de tiempos discreta y centrada
tp = n1*(Ts/rate); % Base de tiempos continua
