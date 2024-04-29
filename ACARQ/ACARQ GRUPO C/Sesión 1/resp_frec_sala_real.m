% Cargar los archivos de audio
[esquina1, fs_esquina] = audioread('esquina1.wav');
[centro1, fs_centro] = audioread('centro1.wav');

% Calcular el número de puntos
numero_pts_centro = 2^ceil(log2(length(centro1)));   
numero_pts_esquina = 2^ceil(log2(length(esquina1)));

% Calculamos la Transformada de Fourier
fft_esquina = fft(esquina1, numero_pts_esquina);
fft_centro = fft(centro1, numero_pts_centro);

% Escalamos los ejes de frecuencia para reflejar la escala real de la sala
x_c = (fs_centro / 10) * (0:(numero_pts_centro - 1)) / numero_pts_centro;
x_e = (fs_esquina / 10) * (0:(numero_pts_esquina - 1)) / numero_pts_esquina;

% Representamos la respuesta en frecuencia
plot(x_e, abs(fft_esquina / max(fft_esquina)), 'k');
hold on
plot(x_c, abs(fft_centro / max(fft_centro)), 'r');
xlim([0, 250]); % Ajustamos los límites del eje x para reflejar la nueva escala
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');
title('Respuesta en frecuencia');
legend('Esquina de la sala real', 'Centro de la sala real');
hold off
