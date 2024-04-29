% Demod de la señal generada de simulink

fmt = transpose(fm);    % transponemos la marriz, ahora la inf va a estar en las columnas
FM=fmt(:);


%tomamos la fs de los parametros de bloque RTL-SDR Receiver
%fs=fmsRzParams
fs=228000;
figure(1),powerspec(FM,1/fs);
%%
% aparatado b
FM1=[0; FM(1:end-1)] % ; pq es un vector columna
w=FM.*conj(FM1);
v=angle(w);

figure(2),powerspec(v,1/fs);
%%
% apartado c
% la funcion de diezmado ya incluye un LPF
s=decimate(double(v),30); %15
sound(s,8000);
figure(3),powerspec(s,1/8000);  % es la suma del canal izq y el derecho
%%





