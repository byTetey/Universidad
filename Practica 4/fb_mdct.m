
M=8;  %Número de filtros
L=2*M;
n=0:L-1;

win=sin((n+0.5)*pi/2/M); %Ventana senoidal
subplot(211), stem(n,win),title('Ventana senoidal');axis([0 L-1 0 1.2]);

hn=[]; %Respuesta impulsional de los distintos filtros (por filas)
Cte=sqrt(2/M);

subplot(212); hold on;

for k=0:M-1
    temp=cos((2*n+M+1)*(2*k+1)*pi/4/M);
    hnew= Cte*win.*temp;   %Generamos un nuevo filtro
    hn=[hn; hnew]; %Lo incorporamos a la matriz como una fila más.
    
    [Hnew,w]=freqz(hnew,1); %Representamos su respuesta en frecuencia
    plot(w,20*log10(abs(Hnew))), xlabel('\omega'),title('|H_k(\omega)|');
    axis([0 pi -60 20]);
        
end
hold off

