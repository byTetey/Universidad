% Dimensiones de la sala (en metros)
L = 0.5; % Longitud
W = 0.5;  % Ancho
H = 0.35;  % Altura

% Leer señales de audio
[esquina1, fs_esquina] = audioread('esquina1.wav');
[centro1, fs_centro] = audioread('centro1.wav');

% Calcular número de puntos para la FFT
numero_pts_centro = 2^ceil(log2(length(centro1)));   
numero_pts_esquina = 2^ceil(log2(length(esquina1)));

% Calculamos la Transformada de Fourier
fft_esquina = fft(esquina1, numero_pts_esquina);
fft_centro = fft(centro1, numero_pts_centro);

% Frecuencias correspondientes a cada punto en la FFT
frequencies_esquina = linspace(0, fs_esquina/2, numero_pts_esquina/2 + 1);
frequencies_centro = linspace(0, fs_centro/2, numero_pts_centro/2 + 1);

% Magnitudes de las FFT
magnitude_spectrum_esquina = abs(fft_esquina(1:numero_pts_esquina/2 + 1));
magnitude_spectrum_centro = abs(fft_centro(1:numero_pts_centro/2 + 1));

% Umbral para considerar un pico significativo
umbral_amplitud = 5;

% Encontrar picos significativos en las FFT
[pks_esquina, locs_esquina] = findpeaks(magnitude_spectrum_esquina, 'MinPeakHeight', umbral_amplitud);
[pks_centro, locs_centro] = findpeaks(magnitude_spectrum_centro, 'MinPeakHeight', umbral_amplitud);

% Función para encontrar modos propios
find_modes = @(frequencies, locs) arrayfun(@(i) fsolve(@(x) norm([x(1)/L, x(2)/W, x(3)/H]) - (2*frequencies(locs(i))/343), [1, 1, 1]), 1:length(locs), 'UniformOutput', false);

% Calcular modos propios desde la esquina
modes_esquina = find_modes(frequencies_esquina, locs_esquina);

% Calcular modos propios desde el centro
modes_centro = find_modes(frequencies_centro, locs_centro);

% Imprimir los resultados
fprintf('Modos propios desde la esquina:\n');
for i = 1:numel(locs_esquina)
    fprintf('Pico %d en %0.2f Hz:\n', i, frequencies_esquina(locs_esquina(i)));
    fprintf('n_x = %d, n_y = %d, n_z = %d\n', round(modes_esquina{i}));
end

fprintf('Modos propios desde el centro:\n');
for i = 1:numel(locs_centro)
    fprintf('Pico %d en %0.2f Hz:\n', i, frequencies_centro(locs_centro(i)));
    fprintf('n_x = %d, n_y = %d, n_z = %d\n', round(modes_centro{i}));
end

