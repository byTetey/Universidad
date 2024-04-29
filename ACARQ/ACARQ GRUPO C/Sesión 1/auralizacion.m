
[vacia, fs_vacia] =audioread('svacia.wav');

[bajo, fs_bajo] = audioread('linea_Cgrave.wav');

%% Método de diezmado y convolución

vacia_diezm=decimate(bajo,10);   % diezmamos en factor de 10 para obtener 
% la señal en la sala objetivo

vacia_diezm_conv = conv(bajo, vacia_diezm);
% convolucionamos la señal original con la señal diezmada

% soundsc(vacia_diezm_conv, fs_bajo/10);
% audiowrite("prueba_diezm.wav",vacia_diezm_conv, fs_bajo/10);
%% Forma inversa, escalando la señal al mundo a escala, convolucionar ambas para posteriormente
 % reescalar de nuevo la salida de la convolución.

%  bajo_interp = interp(bajo, 10);
% vacia_conv_interp = conv(bajo_interp, bajo);
[bajo_rapido fs_rapida]=audioread("svacia.wav");
bajo_interpolado=interp(bajo_rapido,10);
soundsc(bajo_interpolado,fs_rapida);

% La función interp(y,L), incrementa la frecuencia de muestreo a
 % f s = fs L,mientras que la función resample(y,P,Q), 
 % remuestrea la señal de tal forma que fs_esquina1_reescalada = fs' = P/ Q
 
% vacia_reescalada = resample(vacia_conv_interp, 1, 10);
% audiowrite("prueba_interp.wav",vacia_reescalada, fs_bajo/10);
% soundsc(vacia_reescalada, fs_bajo*1/10);
