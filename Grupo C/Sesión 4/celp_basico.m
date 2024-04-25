function [sh_full,B,G,AK,Tv,indv, bits_muestra]=celp_basico(s,Ltrama,Lsubtrama,p, display)

ventana = ones(1,Ltrama);
num_frames = floor(length(s)/length(ventana));
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
B = [];
G = [];
AK = [];
Tv = [];
indv = [];
bits_muestra = 0;
t_final = 1;
l_final = 1;
sh_full = [];

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
	Etestoc_ant = 10000; %Se inicializan las energias a valores altos, que se irá reduciendo a medida que se hayan indices con energias menores
	
    for t=1:(2*Lsubtrama + 1) %La t va a valer 1-81 si son de 40, porque cada vector de la adaptativa va a ser 1:40, 2:41, 3:43, etc..., hasta 80:120
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
        
        b = (s_st*y20')/((norm(y20)^2) + eps); %usar variable eps, sumarle a este valor norm(y20) + eps %productor escalar
        y2 = b*y20;
        u0 = s_st - y2;
      
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
    [y20, filtro_adap] = filter(1, ak, d20,filtro_adap);
    b = (s_st*y20')/((norm(y20)^2) + eps); %usar variable eps, sumarle a este valor norm(y20) + eps para que no dea 0
    y2 = b.*y20; %Esto es y2
    u0 = s_st - y2;
    B = [B b];

    for l=1:size(v,1)
        [y10, filtro_estoc_final] = filter(1, ak, v(l,:), filtro_estoc);
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
    [y10, filtro_estoc] = filter(1, ak, v(l_final,:),filtro_estoc); 
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
    
    sh = y1 + y2;
    sh_full = [sh_full sh]; %Calculo de SNR, recortar la señal original para poder comparar con el tamaño de esta (Ltrama*num_frames)
    bits_muestra = ceil((8*2*4 + 9*4 + 7*4 + (3*size(ak,2)))/Ltrama); %Son 2 ganancias por cada subtrama (4 subtramas), 9 bits por cada subtrama, 7 por cada subtrama, 3 bits a nivel de trama, y se divide entre tamaño de trama, cogiendo un numero entero
    if (display==1)
    figure(1)
    %Descomentar en función de lo que se quiera mostrar
    %subplot(611),plot(0:(Lsubtrama-1),s_st); xlabel('n');ylabel('s'),grid,
    %subplot(612),plot(0:(Lsubtrama-1),sh); xlabel('n');ylabel('sh'),grid,
    %subplot(613),plot(-(3*Lsubtrama):-1,d_temp); xlabel('n');ylabel('d'),grid,
    %subplot(614),plot(0:(Lsubtrama-1),d1); xlabel('n');ylabel('d1'),grid,
    %subplot(615),plot(0:(Lsubtrama-1),d2); xlabel('n');ylabel('d2'),grid,
    %subplot(616),plot(0:(Lsubtrama-1),u0); xlabel('n');ylabel('u0'),grid

    subplot(411),plot(0:(Lsubtrama-1),s_st); xlabel('n');ylabel('s'),grid,
    subplot(412),plot(0:(Lsubtrama-1),sh); xlabel('n');ylabel('sh'),grid,
    subplot(413),plot(0:(Lsubtrama-1),y1); xlabel('n');ylabel('y1'),grid,
    subplot(414),plot(0:(Lsubtrama-1),y2); xlabel('n');ylabel('y2'),grid,
    pause;
    end
end
end
end