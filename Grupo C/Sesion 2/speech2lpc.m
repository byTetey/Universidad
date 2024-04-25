function [LPC, Ep, RC, LSF, LAR]=speech2lpc(s, p, window, wshift)

% s: señal de voz o sonora.
% p: orden de predicción
% window, wshift: ventana a utilizar y su desplazamiento en muestras.

% Salidas: parámetros correspondientes a cada trama por filas.
% LPC, Ep: LPCs (matriz) y energía del error de predicción (vector).
% RC: coeficientes de reflexión (matriz)
% LSF: Line Spectral Frequencies (matriz)
% LAR: Log Area Ratios (matriz)

% LARs y LSFs utilizando funciones rc2lar y poly2lsf.
% Extraed los parámetros de todas las tramas del archivo tvg_10minutos_8khz.wav (ventana
% rectangular de 160 muestras, desplazamiento 160, p = 10). Guardadlos en el fichero
% LPCpar.mat. Este será nuestro material de entrenamiento.
% Con la función bsVQ (ε = 0,025, th = 0,001) entrenad VQs de 10 bits para los LPC, RC,
% LSF y LAR (VQLPC, VQRC, VQLSF, VQLAR)
% En el diseño de VQLPC no consideréis el primer coeficiente (siempre uno). Cuidado con
% vectores fila y columna en todos los pasos

s=reshape(s,1,length(s));

% Calcular el número de tramas
num_frames = floor(length(s)/wshift);

%Inicializamos las matrices
LPC = zeros(p, num_frames);
Ep = zeros(1, num_frames);
RC = zeros(p, num_frames);
LSF = zeros(p, num_frames);
LAR = zeros(p, num_frames);

% Obtencion de LPCs, RCs y EP de cada trama

for i = 1:num_frames    

    frame = frames(s,i,wshift,window) ;
    %frame=frame(:);
    % Cálculo de LPCs, RCs y Ep
    Rcorr = xcorr(frame, frame);
    Rcorr = Rcorr(length(frame):length(frame) + p);
    [ak, ep, rc] = levinson(Rcorr, p);

    % Cálculo de LARs y LSFs solo si los coeficientes LPC son válidos
    lar = rc2lar(rc);
    lsf = poly2lsf(ak);
    
    % Almacenar en matrices
    LPC(:, i) = ak(2:end);  % Excluye el primer coeficiente
    Ep(i) = ep;
    RC(:, i) = rc;
    LAR(:, i) = lar;
    LSF(:, i) = lsf;
    
    % Cálculo de LARs y LSFs
    lar = rc2lar(rc);
    lsf = poly2lsf(ak);

    % Almacenar en matrices
    LPC(:, i) = ak(2:end);  % Excluye el primer coeficiente
    Ep(i) = ep;
    RC(:, i) = rc;
    LAR(:, i) = lar;
    LSF(:, i) = lsf;
end

LPC=LPC';
RC=RC';
LSF=LSF';
LAR=LAR';

% Guardamos los archivos en 'LPCpar.mat'
save('LPCpar.mat', 'LPC', 'Ep', 'RC', 'LSF', 'LAR');

end