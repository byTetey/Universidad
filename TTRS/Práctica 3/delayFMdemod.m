
close all;

fs=32000;		% Frec de muestreo (Hz)
kf= 800; 		% Cte de desviacion de frec (Hz/V)
fc=3000; 		% Frec de portadora (Hz)
fm= 200; 		% Frec moduladora (Hz);, modifica que tan separadas estas las componentes en la representación de la DEP

N=100000; 		% Number of samples

n=0:N-1;
Ts=1/fs;
t=n*Ts; 		% Sampling times
j=sqrt(-1);
m=sin(2*pi*fm*t); % Modulating signal, señal moduladora
xfm=cos(2*pi*fc*t+2*pi*kf*cumsum(m)*Ts)+sqrt(VN)*randn(1,length(t)); % FM signal

figure(1);
nn=1:500;
subplot(211),plot(t(nn),m(nn));
subplot(212),plot(t(nn),xfm(nn));

figure(2);
powerspec(xfm,Ts);
%%

% 3.2.2 Complex Delay Line Discriminator [1] [4]
%Receptor
difff=2000; % diferencia de frecuencia entre portadora y demoduladora
xbb=xfm.*exp(-j*2*pi*(fc+difff)*t); % la se�al xfm en banda base

%%
L=400;
h=firpm(L,[0 3600 4000 fs/2]/(fs/2),[1 1 0 0]);
xbb=filter(h,1,xbb);
xbb=xbb(L/2+1:end); %Equivalente de banda base. ybb se podria diezmar, lo que 
                    % ya incluiria el filtro paso bajo
% Es la parte anticausal de la se�al, lo que est� antes del cero, que tiene
% una longitud L/2. A partir de aqu� es influyente esta parte de la se�al.

figure(3);
powerspec(xbb,Ts);
%%
% Demodulaci�n
% creamos vector de enrada con retardo
y1=[0 xbb(1:end-1)]; % le quitamos una al final para que tengan la misma longitud para poder multip.
% calulamos el producto de la se�al retardada y conjugada de la se�al
w=xbb.*conj(y1);
% calc. el angulo de la exponencial compleja resultante
v=angle(w);

figure(4);
subplot(211),plot(t(nn),m(nn));
subplot(212),plot(t(nn),v(nn));
%%
% EN FM, Beta =kf/fm
% TENGO UNA FOTO DE COMO CALCULAR LA POTENCIA MEDIA DE LAS COMPONENTES
% SELECCIONADAS
beta=kf*max(abs(m))/fm;
% SIENDO BETA =1, HAY 4 ORDENES, EL DE J(0),J(1),J(2) Y J(3)
sxp=1/4*(besselj(0,beta))^2;


