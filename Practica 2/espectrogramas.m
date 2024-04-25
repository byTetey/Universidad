load spec_colormap.mat; %Leemos el mapa de color que aplicaremos posteriormente.
pause off;
%Leemos la señal de voz, la frecuencia de muestreo y el
%número de bits por muestra.

[speech,fs]=audioread('paulo8khz.wav');

%Eje temporal
time=(0:length(speech)-1)/fs;
plot(time,speech);
pause;

speech=reshape(speech,1,length(speech));
window=hamming(281)';


number_of_frames=floor(length(speech)/160)+1;


%Para cada trama obtenemos su espectro. 
% La longitud de la trama es de 281 muestras (la de la ventana)
% y el desplazamiento es de 160 muestras.

SpeechSpectrum=[];

for i=1:number_of_frames
    i % Muestra el número de trama
    [speech_frame,ori_signal]=frame(speech,i,160,window);
    spe=abs(fft(speech_frame,1024));
    spe=spe(1:1024/2+1);
    SpeechSpectrum=[SpeechSpectrum; spe];   % vamos apilando las filas
end
clf; colormap(spec_colormap);  
time=(1:number_of_frames)*160/fs;
fHz = ((0:1024/2)/1024)*fs; 
mesh(time,fHz,SpeechSpectrum');
xlabel('time (s)');
ylabel('frequency (Hz)');
pause;

%Con el módulo en dB

mesh(time,fHz,20*log10(SpeechSpectrum'));
xlabel('time (s)');
ylabel('frequency (Hz)');

pause;

%Vista desde el eje z

view(0,90);

pause;

% Hemos obtenido un espectrograma en color, aunque normalmente
%se representa en niveles de gris.

a=colormap('gray');
colormap(1-a.^6);

pause;


%*******************************************************************
% EJERCICIO: Interpreta el espectrograma previo.¿Es de banda ancha o
% de banda estrecha?
%*******************************************************************
%   banda estrecha ya que tiene mucha resolucion en frecuencia 

% Ahora repetimos el análisis trama a trama pero con una longitud
% de trama de 51 muestras y un desplazamiento de 40.

[speech,fs]=audioread('paulo8khz.wav');
speech=reshape(speech,1,length(speech));
window=hamming(51)';

number_of_frames=floor(length(speech)/40)+1;

SpeechSpectrum=[];

for i=1:number_of_frames
    i % Muestra el numero de trama
    [speech_frame,ori_signal]=frame(speech,i,40,window);
    spe=abs(fft(speech_frame,1024));
    spe=spe(1:1024/2+1);
    SpeechSpectrum=[SpeechSpectrum; spe];
end
clf; colormap(spec_colormap);  
time=(1:number_of_frames)*40/fs;
mesh(time,fHz,SpeechSpectrum');
xlabel('time (s)');
ylabel('frequency (Hz)');
pause;

%Con el módulo en dB

mesh(time,fHz,20*log10(SpeechSpectrum'));
xlabel('time (s)');
ylabel('frequency (Hz)');

pause;

%Visualización desde el eje z.

view(0,90);

pause;

a=colormap('gray');
colormap(1-a.^6);

pause;


%*******************************************************************
% EJERCICIO: Interpreta de nuevo el espectrograma previo. ¿Es de banda
% ancha o de banda estrecha.
%*******************************************************************


%Matlab tiene su propia función para representar espectrogramas.

specgram(speech,1024,8000,251,160);

pause;

a=colormap('gray');
colormap(1-a.^6);



