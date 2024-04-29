function frecuencias_fundamentales = getFundamentalFrequency(notas, frecuencias_muestreo)
    num_notas = numel(notas);
    frecuencias_fundamentales = zeros(1, num_notas);

    for i = 1:num_notas
        % Calcular la autocorrelación de la nota
        R = xcorr(notas{i});

        % Nos quedamos solo con el semieje positivo
        R = R(length(notas{i}):end);

        % Cálculo del índice de mayor amplitud sin contar el primero (periodo fundamental)
        [~, ind_R] = max(R(400:round(length(R)/2)));

        % Cálculo de la frecuencia fundamental
        frecuencias_fundamentales(i) = frecuencias_muestreo(i) / (ind_R + 400);
    end
end
