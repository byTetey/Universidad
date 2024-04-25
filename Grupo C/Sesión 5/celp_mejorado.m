function [sh_full,B,G,AK,Tv,indv, bits_muestra]=celp_mejorado(s,Ltrama,Lsubtrama,p, display)

% sh, señal de voz reconstruida
% B y G vectores con las ganancias adaptativa y estocástica de las
% distintas subtramas
% Ak, matriz con los LPC de cada trama
% bits_muestra, número de bits por muestra.
% s, señal de voz
% Tv, vector con los distintos valores de T en la excitación adaptativa.
% indv, vector con los distintos índices seleccionados de la excitación estocástica.
% Ltrama y Lsubtrama, longitudes de trama y subtrama.
% p, orden de predicción.

ventana = ones(1,Ltrama);
num_frames = floor(length(s)/length(ventana)) +1;
%s=reshape(s,1,length(s));
s=s';

d = zeros(1,3*Lsubtrama);
%d_temp = -0.4 + 0.8 * rand(1, 3*Lsubtrama);
M = 512; 
N=Lsubtrama; 
rng(1); 
v = randn(M,N); %Vector de entrada de la contribución estocástica
filtro_estoc = [];
filtro_adap = [];
filtro_Wz = [];
filtro_final_y1 = [];
filtro_final_y2 = [];
B = [];
G = [];
AK = [];
Tv = [];
indv = [];
bits_muestra = 0;
t_final = 1;
l_final = 1;
sh_full = [];
cte=0.8;

for j = 1:num_frames %Las operaciones por tramas son iguales para la biblioteca adaptativa y estocástica
    
    
    tramas = frames(s,j,Ltrama,ventana);
    [ak, ~] = lpc(tramas, p);
    AK = [AK ak];

for i=1:length(tramas)/Lsubtrama %Mal, Seleccion de indices de una subtrama a otra para minimizar error
    %Parte estocástica y adaptativa (x1 estocástica, x2 adaptativa)

    %subtrama_actual = tramas((i - 1) * Lsubtrama + 1 : i * Lsubtrama);

    %Se extraen indices, 1 por cada subtrama, y luego se reconstruye la
    %señal por subtramas tambien, pero usando solo la parte de las
    %librerias estocasticas y adaptativas optimas

    %Tmax = 3*Lsubtrama;
    %Tmin = Lsubtrama; %depende de subtrama

	Etadap_ant = 10000;
	Etestoc_ant = 10000;
    %Se inicializan las energias a valores altos, que se irá reduciendo a medida que se hayan indices con energias menores
	
    for t=1:(2*Lsubtrama + 1)  %La t va a valer 1-81 si son de 40, porque cada vector de la adaptativa va a ser 1:40, 2:41, 3:43, etc..., hasta 80:120
        %T = 3*Lsubtrama - t + 1;   %de T se pasa a t y viceversa
        d20 = d(t:Lsubtrama+t-1);
        [y20, filtro_adap_final] = filter(1, ak, d20, filtro_adap); %Las condiciones iniciales se mantienen de una busqueda a otra, pero no entre candidatas, se guarda esto al acabar la busqueda para esta subtrama
        s_st = tramas((i - 1) * Lsubtrama + 1 : i * Lsubtrama);
        %Primero se hace una busqueda con los filtros, y luego con el
        %resultado, se filtra una ultima vez usando el valor correcto
        %cuantos bits por tramas necesitas (4 subtramas) (bits por muestra
        %= bits totales / numero muestras (hay cosas que son a nivel de subtrama y otras
        %a nivel de trama) 
        %d empieza valiendo 0

        coef_modif = 0.8.*ak;
        [u, filtro_Wz] = filter(ak, coef_modif ,s_st, filtro_Wz);
        
        b = (u*y20')/((norm(y20)^2) + eps); %usar variable eps, sumarle a este valor norm(y20) + eps %productor escalar
        y2 = b*y20;
        u0 = u - y2;
      
        Etadap = norm(u0)^2; %Inicializar error a valor elevado
            if (Etadap < Etadap_ant)
                t_final = t;
                Etadap_ant=Etadap;
            end
        
    end
    
    T = 3*Lsubtrama - t_final + 1;
    Tv = [Tv T];
    %Calcular aqui u0 en base a la candidata
    d20 = d(t_final:Lsubtrama + t_final - 1);
    [y20, filtro_adap] = filter(1, coef_modif, d20,filtro_adap);
    b = (u*y20')/((norm(y20)^2) + eps); %usar variable eps, sumarle a este valor norm(y20) + eps para que no dea 0
    y2 = b.*y20; %Esto es y2
    u0 = u - y2;
    B = [B b];

    for l=1:size(v,1)
        [y10, filtro_estoc_final] = filter(1, coef_modif, v(l,:), filtro_estoc);
        g = (u0*y10')/(norm(y10)^2);
        y1 = g*y10;
        uf = u0 - y1;
        
        Etestoc = norm(uf)^2;
            if (Etestoc < Etestoc_ant)
                l_final = l;
                Etestoc_ant=Etestoc;
            end
    end

    %filtro_estoc = filtro_estoc_final;  
    indv = [indv l_final];
    [y10, filtro_estoc] = filter(1, coef_modif, v(l_final,:),filtro_estoc); 
    g = (u0*y10')/(norm(y10)^2);
    y1 = g*y10; 
    %uf = u0 - y1; 
    G = [G g];
    %reordenar la señal de train para que quede 20000x2, se cuantifica, y
    %luego para la snr se hace lo inversa

    d1 = g*v(l_final,:);
    d2 = b*d20;

    d_temp = d1 + d2; 
    d = [d((Lsubtrama + 1):end), d_temp];  

    %Repetir todo el proceso anterior para los indices correctos
    % Por tanto, para reconstruir la señal de voz será necesario:
    % pasar y1[n] + y2[n] por el filtro 1/W(z).
    [y1_filt, filtro_final_y1] = filter(coef_modif, ak, y1, filtro_final_y1);

    [y2_filt, filtro_final_y2] = filter(coef_modif, ak, y2, filtro_final_y2);

    sh = y1_filt + y2_filt;    

%     sh = y1 + y2;
    sh_full = [sh_full sh]; %Calculo de SNR, recortar la señal original para poder comparar con el tamaño de esta (Ltrama*num_frames)
    
    bits_muestra = ceil((8*2*4 + 9*4 + 7*4 + (3*size(ak,2)))/Ltrama); %Son 2 ganancias por cada subtrama (4 subtramas), 9 bits por cada subtrama, 7 por cada subtrama, 3 bits a nivel de trama, y se divide entre tamaño de trama, cogiendo un numero entero
   

    %Son 2 ganancias por cada subtrama (4 subtramas), 9 bits por cada subtrama estocastica, 
    % 7 por cada subtrama adaptativa, 3 bits a nivel de trama LPC, y se divide entre tamaño de trama, cogiendo un numero entero

    if (display==1)
    figure(1)
    %Descomentar en función de lo que se quiera mostrar
    subplot(611),plot(0:39,u); xlabel('n');ylabel('u'),grid;axis tight;
    subplot(612),plot(-120:-1,d); xlabel('n');ylabel('d'),grid;axis tight;
    subplot(613),plot(0:39,d2); xlabel('n');ylabel('d2'),grid;axis tight;    
    subplot(614),plot(0:39,y1); xlabel('n');ylabel('y1'),grid;axis tight;
    subplot(615),plot(0:39,y2); xlabel('n');ylabel('y2'),grid;axis tight;
    subplot(616),plot(0:39,sh); xlabel('n');ylabel('sh'),grid;axis tight;

%     subplot(411),plot(0:39,s_st); xlabel('n');ylabel('s'),grid,
%     % subplot(411),plot(0:39,u); xlabel('n');ylabel('s'),grid,
%     subplot(412),plot(0:39,sh); xlabel('n');ylabel('sh'),grid,
%     subplot(413),plot(0:39,y1); xlabel('n');ylabel('y1'),grid,
%     subplot(414),plot(0:39,y2); xlabel('n');ylabel('y2'),grid,

%     subplot(511),plot(0:39,u); xlabel('n');ylabel('u'),grid;axis tight;
%     subplot(512),plot(-120:-1,d); xlabel('n');ylabel('adapt.'),grid; axis tight;
%     subplot(513),plot(0:39,d2); xlabel('n');ylabel('d2'),grid; axis tight;
%     subplot(514),plot(0:39,y2); xlabel('n');ylabel('y2'),grid; axis tight;
%     subplot(515),plot(0:39,sh); xlabel('n');ylabel('sh'),grid; axis tight;
    pause;
    end
end
end
end