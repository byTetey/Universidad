function DibujarConstelacion(s,t,Ts,T0,Tmin,Tmax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          %
% Dibuja una constelacion. %
%                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Indexes = PtosMuestreo(t,Ts,T0,Tmin,Tmax); % Encontrar puntos de muestreo
L = length(Indexes); % Numero de puntos a muestrear
% 
% Dibujar.
%
figure;hold on;axis([-1.5 1.5 -1.5 1.5]); % Configurar grafico
for i=1:L
    % Pintar los puntos
    plot(real(s(Indexes(i))),imag(s(Indexes(i))),'o');
end
