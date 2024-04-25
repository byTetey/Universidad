pause off;

[speech,fs]=audioread('iago800_7.wav');
speech=reshape(speech,1,length(speech));

N=281; window_shift=160;

%window=hamming(N)';
window=ones(1,N);   %Ventana rectangular
window_energy=(window*window');
window=window/sum(window); % Normalización típica

number_of_frames=floor(length(speech)/window_shift);
[Ceps m frame]=stCeps(speech,[1:number_of_frames],window, window_shift,1024);
time=m/fs;

% Solamente nos quedamos con unos cuantos coeficientes

Ceps=Ceps(:,1:256);

nframe=40; % Puedes seleccionar aquí una trama distinta.

subplot(211),plot(frame(nframe,:));
subplot(212),stem(Ceps(nframe,2:256),'.');

%Descartamos el primer coeficiente ya que está relacionado con la energía
% y en valor absoluto es mucho mayor
% que los demás;
%Ampliamos un poco más.

pause

intervalo=40:128;
subplot(212),stem(intervalo,Ceps(nframe,intervalo+1),'.');

% Se observa que hay un pico marcado en la muestra 94.
% Ese valor es precisamente el del periodo fundamental P (fo=8000/94=85 Hz)

%Ejercicio: selecciona una trama sorda y observa su cepstrum.
% PARA UNA TRAMA SORDA: 
% nframe=39  SE OBTIENE DE DIVIDIR EL NUMERO DE MUESTRA/DESPLAZAMIENTO
%  6277/160



