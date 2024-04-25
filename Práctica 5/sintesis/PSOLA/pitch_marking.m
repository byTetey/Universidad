function [s pm f0 fs]=pitch_marking(filename, MIN_F0, MAX_F0, at_max, disp)


% Autor de la función: Eduardo Rodríguez Banga. Universidad de Vigo. SPAIN
%
% Método original: "Epoch Extraction From Speech Signals" by K. Murty and  B. Yegnanarayana
% IEEE Transactions on Audio, Speech, and Language Processing, Vol. 16, No. 8. 
%(November 2008), pp. 1602-1613. 
%
% Salidas:
% s: Señal de voz
% pm: matriz con dos filas. La primera indica las muestras de las marcas de pitch. La segunda la sonoridad 
% (1 o 0) de cada una de las marcas.
% f0: frecuencia fundamental estimada a partir de las marcas y su sonoridad, ligeramente suavizada.
%
% Entradas:
%
% filename: fichero wav
% MIN_F0 y MAX_F0: valores mínimo y máximo de frecuencia fundamental. Cuanto más ajustados al locutor, mejor.
% at_max: si distinta de cero ajusta las marcas a los máximos locales.
% disp: muestra gráfica con resultados.
%
%Ejemplo [s pm f0 fs]=pitch_marking('paulo8khz.wav',60,180,0,1);



UNVOICED_marks=100; %frec. marcas pitch sordas en Hz

[speech,fs]=audioread(filename);
s=reshape(speech,1,length(speech)); % Me aseguro de que sea un vector fila
s=s-mean(s); % Elimino componente continua si la hay.

%No me funcionaba el método por una componente de unos 50Hz que voy a eliminar.
NN=800; %Orden del filtro FIR de fase lineal
b=fir1(NN,60/(fs/2),'high'); 
s=filter(b,1,s); % Elimino componentes por debajo de 60Hz 
s=[s(NN/2+1:end) zeros(1,NN/2)]; %Compenso el retardo de grupo del filtro.


%Aquí comienza el algoritmo descrito en el artículo

N=round(0.010*fs/2); %Muestras en 10ms (20ms aprox 2N+1 muestras). Un poco mayor que en el artículo.


den=[1 -2 1];
den=conv(den,den); %Los dos resonadores pasobajo en un único filtro

x=filter([1 -1],1,s); %señal diferencia
y2=filter(1,den,x); % La y2[n] del articulo


%El siguiente bucle lo intenté implementar como un único filtro pero tenía
%algún problemilla, así que, si acaso, lo pondré bonito más adelante.
y=[];
for i=1:length(y2)
    if (i>N) && (i<length(y2)-N)
        y(i)=y2(i)-sum(y2(i-N:i+N))/(2*N+1);
    else
        y(i)=0;
    end
end

vimpulses=-ones(1,length(s)); %Señal que vale -1 donde no hay marcas. Inicialmente toda a -1

y_sign=sign(y);
ind=find(diff(y_sign)==2)+1; % Localizo los cruces por cero con pendiente positiva

diff_ind=diff(ind);

%Chapuza para situar las marcas de pitch en los máximos de la forma de onda
if (at_max)
    for i=1:length(diff_ind)
        [Mmax imax]=max(s(ind(i):ind(i)+floor(diff_ind(i)/2)));
        ind(i)=ind(i)+imax;
    end
end

vimpulses(ind)=1;   % Pongo un 1 donde hay marcas de pitch.

%La parte siguiente ya es original mía y simplemente trato de aprovechar
%la distancia entre marcas para clasificarlas como sordas o sonoras y solucionar
%algunos problemas aislados. Creo que para que funcione adecuadamente es necesario
%que haya un segmento sordo o silencio al principio y al final. Así con la
%señal test.wav el método detecta las marcas correctamente, aunque luego las clasifica 
%incorrectamente como sordas.

dist_ind=diff(ind); %Calculo la distancia entre marcas
delete_ind1=find(dist_ind>fs/MIN_F0); %Detecto marcas muy distantes entre sí
vimpulses(ind(delete_ind1))=-2;  % Indico estas marcas con un -2

ind=find(vimpulses==1); % Detecto dónde están las marcas
dist_ind=diff(ind); % Calculo la distancia entre marcas
delete_ind2=find(dist_ind>fs/MIN_F0); %Detecto una vez más marcas muy distantes entre sí.
vimpulses(ind(delete_ind2))=-1.5; % Indico estas marcas con un -1.5

ind=find(vimpulses==1); % Detecto dónde están las marcas
voiced_pm=ind; %Las marcas situadas hasta ahora son inicialmente marcas sonoras
dist_pm=diff([0 voiced_pm]); %Distancia entre marcas

ind_unvoiced=find(dist_pm>fs/MIN_F0); % Las marcas muy distanciadas entre sí serán sordas
lim_sup=[ind(ind_unvoiced) length(s)]; %límites superiores de intervalos no sonoros.

dist_pm2=diff(voiced_pm);
ind_unvoiced2=find(dist_pm2>fs/MIN_F0);
lim_inf=[1 ind(ind_unvoiced2)];  %Límites inferiores de los intervalos no sonoros.

T0u=round(fs/UNVOICED_marks); % Separación entre marcas sordas que situaré en los intervalos sordos.
unvoiced_pm=[];
for i=1:length(lim_inf)
    nmarks=floor((lim_sup(i)-lim_inf(i))/T0u); %Número de marcas sordas a insertar.
    if(nmarks) unvoiced_pm=[unvoiced_pm round(lim_inf(i)+(1:nmarks)*T0u-T0u/2)];
    end
    
end

%if(lim_sup(end-1)>lim_inf(end)) %Soluciona problema aislado
%     nmarks=floor((length(s)-lim_sup(end-1))/T0u);
%     if(nmarks) unvoiced_pm=[unvoiced_pm round(lim_sup(i)+(1:nmarks)*T0u-T0u/2)];
%     end
%end

uimpulses=-ones(1,length(s)); %vector que valdra -1 salvo que haya una marca sorda
uimpulses(unvoiced_pm)=1;


% Concateno los vectores de marcas sonoras y sordas en la primera fila y en
% una segunda indico su sonoridad (1-sonora, 0-sorda)
pm=[voiced_pm unvoiced_pm; ones(1,length(voiced_pm)) zeros(1,length(unvoiced_pm))]; 
%Los ordeno según el instante temporal
pm=sortrows(pm')';

% Si hay una marca sonora rodeada de dos sordas a izquierda y derecha, la
% transformo en sorda.
temp_ind=findstr(pm(2,:),[0 0 1 0 0])+2;
if(length(temp_ind)) pm(2,temp_ind)=0;
end

%Obtengo las marcas sonoras y sordas
v_ind=find(pm(2,:)==1);
u_ind=find(pm(2,:)==0);
%Estimo la frecuencia fundamental
f0=[0 fs./diff(pm(1,:))];
%Suavizo promediando 7 valores consecutivos
f0=filter(ones(1,7)/7,1,f0);
%f0=0 si la marca es sorda. 
f0(u_ind)=0;

        
if(disp)

    figure(1);
    time=(0:length(s)-1)/fs;
    subplot(211),plot(time,s,'b'),grid;
    temp=axis;
    temp(2)=length(s)/fs;
    axis(temp);
    axis_info=axis;
    xlabel('times');

    coorx=[1 1]'*(pm(1,v_ind)-1)/fs;
    coory=[ones(1,length(v_ind))*axis_info(3);ones(1,length(v_ind))*axis_info(4)];
    line(coorx,coory,'Color','r','LineStyle','-');

    coorx=[1 1]'*(pm(1,u_ind)-1)/fs;
    coory=[ones(1,length(u_ind))*axis_info(3);ones(1,length(u_ind))*axis_info(4)];
    line(coorx,coory,'Color','g','LineStyle','-');
    
    subplot(212),plot(pm(1,:)/fs,f0);
    temp=axis;
    temp(2)=length(s)/fs;
    axis(temp);
    ylabel('f_0 (Hz)');
    xlabel('times');

end




   
    
    
   
    
   

 