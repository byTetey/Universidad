function encodedVideo = CodVideo(video, Q)
%%%%%%%%%%%%%%%%%%%%%
% Codificacion Video %
%%%%%%%%%%%%%%%%%%%%%
% Codificar por bloques

% NB: Número de bloques en una dimensión (8x8)
NB = length(Q);

% Obtener el número de frames en el video
numFrames = size(video, 3);

% Inicializar la estructura para almacenar el video codificado
encodedVideo = struct('FrameData', cell(1, numFrames/NB), 'Height', size(video, 1), 'Width', size(video, 2));
t=0;
    for iframe = 1:NB:numFrames
        im0 = video(:, :, iframe); % Extrae el frame en escala de grises
        [rows, cols] = size(im0);
        encodedFrame.Blocks = cell(1, (rows / NB) * (cols / NB));
        k = 0;
        % Codificacion por bloques
        for row = 1:NB:rows
            for col = 1:NB:cols
                bloque = video(row:row+NB-1, col:col+NB-1, iframe:iframe+NB-1);                
                bloquedct3D = DCT3D(bloque);
                bloqueq = round(bloquedct3D./Q);
                bloques = Serializar3D(bloqueq);
                bloquebin = HuffmanCod(bloques);                
                k = k+1;
                encodedFrame.Blocks{k} = bloquebin;
                disp(['iframe: ', num2str(iframe), ', row: ', num2str(row), ', col: ', num2str(col), ', k: ', num2str(k)]);
            end
        end
     t=t+1;
    % Almacenar los datos del frame codificado en la estructura principal
     encodedVideo(t).FrameData = encodedFrame;
    end
end