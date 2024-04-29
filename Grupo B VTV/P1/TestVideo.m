function [PSNR, Compress] = TestVideo(fichvideo)
    % Probar el codificador y decodificador de video en escala de grises

    [~, ~, ext] = fileparts(fichvideo);
    switch lower(ext)
        case '.y4m'
            formato = 'y4m';
        case {'.mp4', '.avi', '.mov'}
            formato = 'otros';
    end

    switch formato
        case 'y4m'
            % Cargar el video en formato Y4M
            [vid0, ~, ~] = LeeY4M(fichvideo, 0);
        case 'otros'
            % Cargar el video en formato MP4, AVI, MOV, etc.
            vid0 = LeeVideo(fichvideo);
        otherwise
            error('Formato no soportado');
    end
    
    Q = Crear3DWatson();
    vid0 = vid0(:,:, 1:16);
    % Obtener información del video
    [filas_fps, columnas_fps, ~, num_fps] = size(vid0);

    % Codificar el video
   VidCod = CodVideo(vid0, Q);
   save('DatosCod.mat', 'VidCod');
%     load('Datos.mat', 'VidCod');
    % Decodificar el video
    vid1 = DeCodVideo(VidCod, Q);
    save('DatosDeCod.mat', 'vid1');

    % Evaluar
%     load('Datos.mat'); 
    PSNR = PSNRdB(vid0, vid1);
    TotalBits = 0;
    for i = 1:length(VidCod)
        for q = 1:length(VidCod(i).FrameData.Blocks)
        TotalBits = TotalBits + VidCod(i).FrameData.Blocks{q}.nbits;
        end
    end
    Compress = (filas_fps * columnas_fps * num_fps * 8) / TotalBits;

    % Imprimir resultados
    fprintf('Video: %s, PSNR: %.2f, Coef. compresion: %.2f.\n', fichvideo, PSNR, Compress);
end
