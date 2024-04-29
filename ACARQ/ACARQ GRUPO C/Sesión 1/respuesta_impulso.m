% Lectura de ambas senales
[centro1, fs_centro] = audioread('centro1.wav');   
[esquina1, fs_esquina] = audioread('esquina1.wav');

t1 = (0:length(centro1)-1) / fs_centro;
t2 = (0:length(esquina1)-1) / fs_esquina;

figure;

subplot(2,1,1);
plot(t1, centro1);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal de audio centro');


subplot(2,1,2);
plot(t2, esquina1);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal de audio esquina');