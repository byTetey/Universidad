
%% SCRIPT PARA PROCESADO DE LOS FICHEROS DE AUDIO PARA MAPA DE PRESIÓN SONORA.
% Versión Marzo 2024
%% Configuración de la Medida
%
%# Tiempo de medida:
% 
% 
% 
T=4;
%#  Frecuencia de muestreo de los filtros de tercio de octava (no tocar). 
fs=48000;
%# Frecuencia de representación del mapa 
fo=250; 
%# Conficuración de los puntos de rejilla (MxN):
M=6; N=5; Num=M*N;
%# Espaciado entre los puntos de medida.
espac=0.05;  
%# Coordenadas del primer punto de medida
coord=[0.05 0.10]; 
%# Análisis tercio de octava, 22 frecuencias centrales
nfrec = 22; 

%% Carga de los ficheros de audio.
% Los ficheros pueden tener cualquier nombre y deben estar en directorio
% bajo la carpeta desde la que se ejecuta el Script.
diractual=pwd;          % Obtenemos el directorio actual
% Carpeta donde almacenamos los ficheros de medida:
dirfiles=input('Nombre de directorio de ficheros: ','s');
% Obtenemos la lista de dicheros en la carpeta. 
lista=[diractual '/' dirfiles '/*.wav']; 
% Obtenemos los nombres de los ficheros en el directorio
ficheros=dir(lista);
nombres=char(ficheros.name); 
% Ordenamos los ficheros por fecha de creación. 
[neil,orden]=sort(datenum({ficheros.date}));
ficheros_ordenados=nombres(orden,:);
[fila,col]=find(ficheros_ordenados=='.'); 

% Si queremos que dibuje el mapa, D=1 en otro caso D=0.
D=1; 

% Inicialización de la matriz de niveles de cada fihero. 
Li=zeros(nfrec,Num); 

%% Carga de los ficheros y cálculo de nivel por banda en cada fichero.
for ii=1:Num,
    
    % A veces hay caracteres en blanco blancos después del .wav y wavread . Garantizamos
    % nombre quedandonos hasta el punto y añadiendo la extensión sin
    % blancos
    nombre=[diractual '/' dirfiles '/' ficheros_ordenados(fila(ii),1:col(ii)) 'wav'];
    progressbar=['                                   ' num2str(Num-ii)]; progressbar(1:ii)='-';
    clc; disp(progressbar);
    proc=['Procesando fichero...' ficheros_ordenados(fila(ii),1:col(ii)) 'wav'];disp(proc);
    [aux,fs2]=audioread(nombre);
   
    n_o=fs;
    n_end = T*fs;
    [L,f] = banco1_3(aux(n_o:n_end),fs);
    Li(:,ii) = L;
end

% Li el nivel de presión sonora en contiene n filas (una por frecuencia) 
% y MxN Columnas (una por punto de medida). 
%% Llamada a la Función de Mapeado
%  Una vez obtenido Li no hace falta volver a reprocesar el mapa. 
%  Cortando y pegando el siguiente código en la línea de comandos,
%  y modificando fo. cambiamos la frecuencia de representación del mapa.  
%  Recomendación: si se salvan las variables Li,f,fo, M,N, espac en un
%  fichero.mat,se pueden recalcular los mapas sin necesidad de volver a
%  procesar los ficheros. 
%%
[P,X,Y]=mapa(Li,f,fo,M,N,coord,espac,D);
view([0 90.0]);
 colorbar;
 xlim=([0 max(max(X))]);
 ylim=([0 max(max(Y))]);
 
