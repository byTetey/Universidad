function SNRq =SNR(x, xq)

% x = señal original
% xq = señal cuantificada

% Calculamos la potencia de la señal
    potencia_senal = sum(x.^2);
    
 % Calcula la potencia del error de cuantificación
    error = x - xq;
    potencia_error = sum(error.^2);

  % Calcula SNR en dB
     SNRq = 10 * log10(potencia_senal / potencia_error);
end