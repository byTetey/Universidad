function [s,t] = PasarAnalogico(SymbolStream,T0,rate)

Ts = T0*rate;
% Crear un vector de tiempo
t = 0:T0:(length(SymbolStream)-1)*rate;

% Generar la señal en deltas
delta_train = zeros(size(t/T0));

% Inicializar índice de símbolos
k = 1;

% Bucle para generar la señal en deltas
for n = 0:(length(SymbolStream)-1)*rate
    % Indice para evitar errores
    i = n+1;

    % Verificar si n*T0 es múltiplo de Ts
    if mod(n, rate) == 0
        % Asignar el símbolo actual al tren de deltas
        delta_train(i) = SymbolStream(k);
        k = k+1;
    end
end

% Obtener el pulso conformador (coseno alzado)
[p,tp] = Pulsob(rate, Ts);

% Convolución de la señal en deltas con el pulso conformador
s = Convolucion(delta_train,t,p,tp);

% Normalizar la señal
s = s*rate;

end