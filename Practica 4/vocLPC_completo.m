
display=0;

[ori_speech,fs]=audioread('paulo8khz.wav');
speech=reshape(ori_speech,1,length(ori_speech));
speech=speech-mean(speech);

% Se define la ventana Hamming de la longitud deseada
% y el desplazamiento de la ventana
speech=filter([1 -0.9],1,speech);
window=hamming(281)';
desp=160;

%Se calcula el número de tramas a procesar.
number_of_frames=floor(length(speech)/desp);

exc_shift=1;     %Situación inicial de la primera delta de la excitación sonora.
syn_speech=[];   % Aquí se guardará la voz sintética.
ini_cond=zeros(1,10); % Valores almacenados en los retardos del filtro LPC

f0_contour=[];

aux=ones(1,desp);

for i=1:number_of_frames %Para cada trama.
    i
    [speech_frame,ori_signal]=frame(speech,i,desp,window);
    
    if(display==1) 
        subplot(211),plot((0:281-1),ori_signal);
        subplot(212),plot((0:281-1),speech_frame);
        pause;
    end;    

[f0, voiced]=pitch_corr(speech_frame,fs);    

% La periodicidad y sonoridad se estiman a partir de la función de autocorrelación de cada trama. 
% Deberás programar la función. Para la detección de la sonoridad utiliza simplemente el cociente 
% entre la amplitud de la autocorrelación correspondiente al periodo fundamental 
% y su valor en el origen, que compararás con un umbral que deberás fijar.

%  function [f0, voiced]=pitch_corr(speech_frame,fs);
% 
%  N=length(speech_frame);
%  speech_corr=xcorr(speech_frame,speech_frame);
%  
%  search_limit=floor((length(speech_corr)-1)/2-20);
%  
%  [p0,p0_index]=max(speech_corr);
%  [p1,p1_index]=max(speech_corr(1:search_limit));
%  
%  voiced=(p1/p0>0.3);
% 
%  if(voiced)
%      pitch_period=p0_index-p1_index;
%      f0=fs/pitch_period;
%  else
%      f0=0;
%  end
    
    f0=1.2*f0;    
    
    if(~voiced) 
        f0=0;
        pitch_period=0;
    else
        pitch_period=floor(fs/f0+0.5);
    end;
     
    [ak,Pp]=lpc(speech_frame,10);       % Pp : potencia del error de preccion
    Ep=Pp*length(speech_frame);
    
    if(~voiced) 
        g=sqrt(Pp);
    else
        g=sqrt(Pp*pitch_period);
    end;

    [exc exc_shift]=excitation(voiced, pitch_period, exc_shift,desp);       %2*desp : aumenta la longitud de la trama. DEBE SER UN NÚMERO ENTERO
    [syn_frame, ini_cond]=filter(g,ak,exc,ini_cond);
    syn_speech=[syn_speech syn_frame];
    
    if(display==1) 
        subplot(211),plot((0:desp-1),ori_signal(1:desp));
        subplot(212),plot((0:desp-1),syn_frame);
        pause;
    end

    f0_contour=[f0_contour f0*aux];     % PARA ALINEARLOS Y PODER REPRESENTARLOS


end
  syn_speech=filter(1,[1 -0.9],syn_speech);         % FILTRO DE-ÉNFASIS
  subplot(311),plot(ori_speech(3000:8000));
  subplot(312),plot(syn_speech(3000:8000));
  subplot(313),plot(f0_contour(3000:8000));
  