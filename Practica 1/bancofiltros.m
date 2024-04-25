% Genero una entrada como suma de tres sinusoides
n=1:1000;
x=2*cos(pi/4*n)+ cos(3*pi/4*n)+ cos(3*(pi/4+pi/64)*n);

% ********************* ENTRADA ALTERNATIVA ******************
% x=randn(1,1000);
% pbj=fir1(3,0.5,'low');
% x=filter(pbj,1,x);
%**************************************************************

[x fs]=audioread('audio1.wav');
x=x';

%Represento el espectro de la entrada
[X w]=freqz(x,1,1024);
plot(w,abs(X));

% Diezmado
x0=filter(h0,1,x);
x1=filter(h1,1,x);

xd0=x0(1:2:end);
xd1=x1(1:2:end);        % Cogemos una de cada dos muestras

% Interpolación

y0=zeros(1,2*length(xd0));
y1=zeros(1,2*length(xd1));

y0(1:2:end)=xd0;
y1(1:2:end)=xd1;

y=filter(f0,1,y0)+filter(f1,1,y1);

%Compensación del retardo

retardo=N;
y=y(retardo+1:end);     % Descartar las primeras muestras de y

plot(x(1:length(y))-y);

