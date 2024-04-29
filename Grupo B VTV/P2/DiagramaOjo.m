function DiagramaOjo(s,t,Ts,rate,Tmin,Tmax,comp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% Dibuja el diagrama de ojo. %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T0 = Ts/rate; % El que faltaba
Indexes = PtosMuestreo(t,Ts,T0,Tmin,Tmax); % Encontrar puntos de muestreo
L = length(Indexes); % Numero de puntos a muestrear
semiancho = round(rate/2); % Mitad del ancho del diagrama
Imax = length(t); % Maximo indice que puede existir
bt = (-semiancho:semiancho)*T0; % Base de tiempos
centro_bt = semiancho+1; % Pto central
% 
% Dibujar.
%
figure;
hold on; % Preparar grafico
for i=1:L,
    % Vamos a centrarlo en cada punto
    centro = Indexes(i);
    inicio = max(1,centro-semiancho);
    fin = min(Imax,centro+semiancho);
    diff = centro_bt-centro;
    % Dibujar
    if (comp==0)
        plot(bt(inicio+diff:fin+diff),real(s(inicio:fin)));
    else
        plot(bt(inicio+diff:fin+diff),imag(s(inicio:fin)));
    end
end
