
display =0; %Poner a 1 para mostrar gráficas.

[speech,fs]=audioread('test.wav');
speech=reshape(speech,1,length(speech));
speech=speech-mean(speech);  %Se elimina la componente continua (valor medio).

% A continuación se realiza el preénfasis de la señal de voz.

speech=filter([1 - 0.9],1,speech);

% Se define la ventana Hamming de la longitud deseada y el desplazamiento
% de la ventana
duracion_ventana= 0.035;
N = duracion_ventana*fs % N=280
window=hamming(281)';
desp=160;

%Se calcula el número de tramas a procesar.

number_of_frames=floor(length(speech)/desp);

exc_shift=1;     %Situación inicial de la primera delta de la excitación sonora.
syn_speech=[];   % Aquí se guardará la voz sintética.
ini_cond=zeros(1,10); % Valores almacenados en los retardos del filtro LPC


aux=ones(1,desp);

for i=1:number_of_frames   %Para cada trama.
    i
    
    %Completa la llamada a la siguiente función
    [speech_frame,ori_signal]=frame(speech,i,desp,window); %Se lee la trama.
    
    if(display==1) 
        subplot(211),plot((0:281-1),ori_signal);
        subplot(212),plot((0:281-1),speech_frame);
        pause;
    end;    
    
    %Se calcula la frecuencia fundamental en Hz y la sonoridad de la trama.
    %voiced=1 si la trama es sonora.
    [f0, voiced]=pitch_corr(speech_frame,fs); % Programa esta funcion
end   
    
%     
% 
%     if(~voiced) 
%         f0=0;
%         pitch_period=0; 
%     else
%         pitch_period=floor(fs/f0+0.5);
%     end;
%     
%     %Predicción lineal  
%     
%     [ak,Pp]=lpc(speech_frame,????);
%     Ep=Pp*length(speech_frame);
%     
%     %Estimación de la ganancia 
%     
%     if(~voiced) 
%         g=????;
%     else
%         g=????;
%     end;
%     
%     %Programa la función "excitation".
%     %Genera la señal de excitación y actualiza exc_shift
%     [exc exc_shift]=excitation(voiced, pitch_period, exc_shift,desp);
%     
%    syn_frame=filter(????,????,????,????);
%    ini_cond=????;
%    
%    syn_speech=[syn_speech syn_frame];
%     
%     if(display==1) 
%         subplot(211),plot((0:desp-1),ori_signal(1:desp));
%         subplot(212),plot((0:desp-1),syn_frame);
%         pause;
%     end
% 
% end
%  
% % Se realiza el deénfasis de la señal sintética.
% 
%  syn_speech=????;
%  
%  subplot(211),plot(speech);
%  subplot(212),plot(syn_speech);