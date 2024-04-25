
%Leyendo de archivo
[s, fs]=audioread('cast.wav');

Tw= 0.0245;   % duración en segundos de la ventana de análisis

%Otras opciones de duración.
% Tw=0.018;
%Tw=0.006;

N=2*floor(Tw/2*fs); %longitud en muestras de la ventana de análisis
                    % Me aseguro de que sea par.
          
number_of_frames=floor(length(s)/(N/2))-1;

y=[];
xp=zeros(1,N); %Para almacenar la IMDCT del bloque previo.

for i=0:number_of_frames-1
        
        ini=i*N/2+1;
        s_mdct=mdct(s(ini:ini+N-1))'; %La longitud de s_mdct es M=N/2
        
        qs_mdct = quantize(s_mdct,5,'scale');       % produce un preeco, antes de que haya un transitorio hay distorsion
        % hace falta aumentar el numero de bits asignado para codificar esa parte 
        %  devuelve los valores de z cuantificados con 5 bits 
        % y ajustando el valor de sobrecarga del cuantificador 
        % al máximo en valor absoluto de la señal.

        x=imdct(qs_mdct)'; %La longitud de x es N=2M.   
        
        temp=xp((N/2)+1:end) + x(1:N/2) ; %Suma solapada, ESTO ES EJERCICIO DE EXAMEN
        
        y=[y temp];
        
        xp=x; %Actualización de la IMDCT del bloque previo.
        
end

y=[y x(N/2+1:end)];

%Si queremos escuchar la señal original
sound(s,fs);

%Si queremos escuchar la señal reconstruida
%sound(y,fs);

%Si queremos representar la diferencia entre la entrada y la salida
% plot(s(1:length(y))-y); title('Error de reconstrucción');
% Si lo queremos escuchar
%sound(s(1:length(y))-y,fs);