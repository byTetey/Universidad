function [syn d]=syslpc_vqq(s, Lframe, p, VQ, par_string)
% Análisis y reconstrucción de una señal mediante predicción lineal
% s: señal de voz.
% Lframe: longitud de la ventana rectangular empleada y del desplazamiento (no hay solape entre tramas)
% p: orden de predicción
% VQ: matrices VQ ya entrenadas(VQLPC,VQRC,VQLSF,VQLAR)
% par_string: cadena para saber si es 'LPC','RC, 'LSF' o 'LAR'
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
    
    s=reshape(s,1,length(s));

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

        switch par_string
    case 'RC'
        
        akrc = poly2rc(ak);
        akrc=akrc';
        [y, errorcuadratico] = VQuantize(akrc, VQ);
        akcuantificado = rc2poly(y);

    case 'LSF'
        
        aklsf = poly2lsf(ak);
        aklsf=aklsf';
        [y, errorcuadratico] = VQuantize(aklsf, VQ);
        akcuantificado = lsf2poly(y);

    case 'LAR'

        akrc=poly2rc(ak);
        aklar = rc2lar(akrc');
        [y, errorcuadratico] = VQuantize(aklar, VQ);
        rc = lar2rc(y);
        akcuantificado = rc2poly(rc);
        
    case 'LPC' 

        columna_unos = ones(size(VQ, 1), 1);
        VQLPC2 = [columna_unos, VQ];
        [y, errorcuadratico] = VQuantize(ak, VQLPC2);
        akcuantificado = y;
    end
       
       for i = 1:size(akcuantificado, 1)
            
        % Predictor corto de análisis
         [y_analisis, zi_predictor_corto_analisis] = filter(akcuantificado(i, :), 1, x, zi_predictor_corto_analisis);
       
        % Predictor corto de síntesis
        [y_sintesis, zi_predictor_corto_sintesis] = filter(1, akcuantificado(i, :), y_analisis, zi_predictor_corto_sintesis);

       end
        
        % Agregar a la señal sintetizada
        syn(start_index:end_index) =  y_sintesis;
        
        % Guardar la diferencia (error de predicción)
        d(start_index:end_index) = y_analisis;
%       end

    end
end