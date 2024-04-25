
function syn_speech = tdpsola( speech, pm, dur_factor, f0_factor,fs )

% Autor de la función: Eduardo Rodríguez Banga. Universidad de Vigo. SPAIN
% 
% speech: vector de muestras con la voz.
% pm: marcas de pitch devueltas por pitch_marking. DURACION
% dur_factor, f0_factor: escalado de duración y f0 (valores típicos entre
% 0.5 y 2) | dur_factor : frecuencia fundamental
% fs: frec. muestreo.
%
%Ejemplo:
%
% [s pm f0 fs]=pitch_marking('paulo8khz.wav', 60, 180, 1, 1);
% syn=tdpsola(s,pm,1,0.7,fs);
% soundsc(syn,fs);


s=speech;
s=reshape(s,1,length(s)); %Me aseguro de que sea vector fila


dist_pm=diff(pm(1,:)); %Distancia entre marcas.

half_length=round(mean(dist_pm)*1.2); %Longitud de la mitad de la ventana (un poco mayor que T0)

dist_pm=[dist_pm dist_pm(end)]; %Distancia entre marcas

w_length=2*half_length+1;  %Longitud de la ventana
window=hanning(w_length)'; %Ventana

s=[zeros(1,half_length) s zeros(1,half_length)]; %Añado ceros al principio y final en previsión de que haya una marca muy cerca del principio o del final.
npm=pm(1,:)+half_length; %Posición de las marcas teniendo en cuenta los ceros añadidos.

segments=[]; %Aquí almaceno los distintos segmentos enventanados

for i=1:length(npm)
     segments=[segments; s(npm(i)-half_length:npm(i)+half_length).*window];

end


temp_npm=cumsum([half_length+1 dist_pm]); %Genero el eje de marcas intermedio
temp_npm=round(temp_npm/f0_factor);



samples=1;
desired_samples=round(length(speech)*dur_factor); %Duración final en muestras

%Aquí guardaré el resultado de la suma solapada 
SEG_SUMA=zeros(1,length(window)+desired_samples+1000-2);




while (samples<=desired_samples)
    
    %Calculo la correspondencia entre marcas (criterio: la más cercana) teniendo en cuenta el distinto
    %escalado temporal.
    [dif selected_pm_index]= min(abs(npm-(samples/dur_factor+npm(1)))); 
    
    selected_pm_index=max([selected_pm_index, 1]);
    temp=[zeros(1,samples-1) segments(selected_pm_index,:) zeros(1,desired_samples+1000-samples-length(segments(selected_pm_index)))];
    SEG_SUMA=SEG_SUMA+temp;

    %La ventana siguiente la centraré distanciada el periodo fundamental
    %deseado.
    samples=samples+round(dist_pm(selected_pm_index)/f0_factor);
   
    
end

%Me quedo con las muestras deseadas.
syn_speech=SEG_SUMA(1:desired_samples);

end %Function



    




