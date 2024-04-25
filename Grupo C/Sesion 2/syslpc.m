function [syn, d] = syslpc(s, Lframe, p)
% Análisis y reconstrucción de una señal mediante predicción lineal
% s: señal de voz.
% Lframe: longitud de la ventana rectangular empleada y del desplazamiento (no hay solape entre tramas)
% p: orden de predicción
%
% syn: señal reconstruída
% d: secuencia d[n] (error de predicción)
    
    N = length(s);
    syn = zeros(N, 1);
    d = zeros(N, 1);

    wshift = length(Lframe);
    s=reshape(s,1,length(s));

    % Condiciones iniciales de los filtros
    zi_predictor_corto_analisis = [];
    zi_predictor_corto_sintesis = [];
    

% Calcular el número de tramas
num_frames = floor(length(s)/wshift);

    for  i = 1:num_frames

         % Segmentar la señal
        start_index = (i - 1) * wshift + 1;
        end_index = min(i * wshift, N);  % Asegura que no supera el final de la señal
    
        % Extrae la trama de la señal
        x = s(start_index:end_index);

        % Análisis LPC
        [ak, G] = lpc(x, p);
        
        % Predictor corto de análisis
        [y_analisis, zi_predictor_corto_analisis] = filter(ak, 1, x, zi_predictor_corto_analisis);
        
        % Predictor corto de síntesis
        [y_sintesis, zi_predictor_corto_sintesis] = filter(1, ak, y_analisis, zi_predictor_corto_sintesis);
        
        % Agregar a la señal sintetizada
        syn(start_index:end_index) =  y_sintesis;
        
        % Guardar la diferencia (error de predicción)
        d(start_index:end_index) = y_analisis;
    end
end