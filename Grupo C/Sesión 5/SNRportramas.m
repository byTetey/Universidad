function [SNRseg, SNRm, m] = SNRportramas(x, xq, L)

N = length(x); %calculamos la longitud de la señal
    num_segmentos = floor(N / L);
    SNRm = zeros(1, num_segmentos); %inicializamos dos vectores para almacenar la SNR por tramas
    m = zeros(1, num_segmentos);

    for i = 1:num_segmentos
        indice_1 = (i - 1) * L + 1;
        indice_2 = i * L;

        segmento_x = x(indice_1:indice_2);
        segmento_xq = xq(indice_1:indice_2);

        senal = mean(segmento_x.^2);
        ruido = mean((segmento_x - segmento_xq).^2);

        SNRm(i) = 10 * log10(senal / ruido); %SNR de cada trama
        m(i) = (indice_1 + indice_2) / 2; %indice para cada trama
    end

    SNRseg = mean(SNRm); %La SNRseg es el valor medio de la SNR por tramas
end