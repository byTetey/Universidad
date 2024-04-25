
%Leyendo de archivo
[s, fs]=audioread('quartet');

Tw= 0.0245;   % duración en segundos de la ventana de análisis

%Otras opciones de duración.
%Tw=0.018;
%Tw=0.006;

N=2*floor(Tw/2*fs) %longitud en muestras de la ventana de análisis
                    % Me aseguro de que sea par.
          
number_of_frames=floor(length(s)/(N/2))-1;

y=[];
xp=zeros(1,N); %Para almacenar la IMDCT del bloque previo.

for i=0:number_of_frames-1
        
        ini=i*N/2+1;
        s_mdct=mdct(????)'; %La longitud de s_mdct es M=N/2
        
        x=imdct(s_mdct)'; %La longitud de x es N=2M.
        
        temp=????; %Suma solapada
        
        y=[y temp];
        
        xp=x; %Actualización de la IMDCT del bloque previo.        
        
end

y=[y x(N/2+1:end)];

%Si queremos escuchar la señal original
%sound(s,8000);

%Si queremos escuchar la señal reconstruida
%sound(y,8000);

%Si queremos representar la diferencia entre la entrada y la salida
plot(s(1:length(y))-y); title('Error de reconstrucción');
% Si lo queremos escuchar
%sound(s(1:length(y))-y,fs);