function videoout = DeCodVideo(VidCod, Q)
    % Decodificar video en escala de grises utilizando la técnica JPEG en bloques
    
    % NB: Número de bloques en una dimensión (8x8)
    NB = length(Q);

    % Obtener la información sobre el video
    numFrames = length(VidCod);
    frameHeight = VidCod(1).Height;
    frameWidth = VidCod(1).Width;

    % Inicializar la matriz para el video decodificado
   % videoout = struct('FrameData', cell(1, numFrames));
    videoout = uint8(zeros(frameHeight, frameWidth, numFrames));
    t = 0;
    % Iterar sobre cada frame del video codificado
    for iframe = 1:NB:numFrames*8
        % Obtener la información del frame codificado
        t=t+1;
        encodedFrame = VidCod(t).FrameData;
        
        % Inicializar matriz para almacenar datos del frame decodificado
        decodedFrame = zeros(frameHeight, frameWidth, NB);
        k=0;
        % Decodificar por bloques dentro del frame        
        for row = 1:NB:frameHeight
            for col = 1:NB:frameWidth                        
                % Incrementar el índice
                k = k + 1;
                bloquebin = VidCod(t).FrameData.Blocks{k};

                % Decodificar Huffman y deserializar
                bloques = HuffmanDeCod(bloquebin, NB^3);
                bloqueq = DeSerializar3D(bloques);

                % Multiplicar por la matriz de cuantización 3D
                bloquedct3D = bloqueq .* Q;

                % Aplicar la inversa de la 3D-DCT al bloque
                bloque = uint8(IDCT3D(bloquedct3D));

                % Actualizar la matriz decodificada
               decodedFrame(row:row+NB-1, col:col+NB-1, :) = bloque;   
               disp(['iframe: ', num2str(iframe), ', row: ', num2str(row), ', col: ', num2str(col), ', k: ', num2str(k)]);
            end
        end

        % Almacenar el frame decodificado en la matriz principal
  
       videoout(:, :, iframe:iframe+NB-1) = decodedFrame; % Sumar sobre la tercera dimensión
    end
end
