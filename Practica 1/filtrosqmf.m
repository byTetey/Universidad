close all;
N=99; %orden de los filtros

%La siguiente línea solo funciona si se dispone del Filter Toolbox
[h0,h1,f0,f1] = firpr2chfb(N,.45);

% Leo los filtros h0,h1,f0 y f1 de un archivo
%load filtrosqmf.mat

fvtool(h0,1,h1,1,f0,1,f1,1);

n=0:length(h0)-1;

figure(1);
subplot(211),stem(0:2*N,1/2*conv(f0,h0)+1/2*conv(f1,h1),'.');
subplot(212),stem(0:2*N,1/2*conv(f0,(-1).^n.*h0)+1/2*conv(f1,(-1).^n.*h1),'.');




