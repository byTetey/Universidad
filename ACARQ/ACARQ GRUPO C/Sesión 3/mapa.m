function [P,X,Y]=mapa(fichero,f,fo,M,N,coord,espac,D);
% Devuelve y representa el mapa de distribución 
% fichero: matriz de medidas, con una frecuencia por fila
% f: Frecuencias de medida
% fo: Frecuencia a la que queremos representar. 0 para global
% M: Número de filas
% N: Número de medidas por fila
% D: 1 si queremos que dibuje
% e: espaciado entre puntos
% coord: (xo,yo), coordenadas del primer punto.

% 0 corresponde con nivel global
indice=find(f==fo);
Mapa=zeros(M,N);
y=zeros(M,2*N-1);
Mapa(1,1:N)=fichero(indice,1:N);

for ii=2:M,
    Mapa(ii,:)=fichero(indice,(ii-1)*N+1:ii*N);
end

P=[Mapa(:,1:N-1) Mapa(:,N) Mapa(:,N-1:-1:1)];

if D==1,
    x=(coord(1):espac:(2*N-1)*espac);
    y=espac*(0:M-1)+coord(2);
    [X,Y]=meshgrid(x,y);
    xi=coord(1):espac/10:(2*N-1)*espac;
    yi=espac*(0:(M-1)/10:M-1)+coord(2);
    [Xi,Yi]=meshgrid(xi,yi);
    Pi=interp2(X,Y,P,Xi,Yi,'cubic');
    h=surf(Xi,Yi,Pi,'FaceColor','interp','EdgeColor','interp');
    hold;
    plot3(X,Y,P,'r*'); hold off;
    set(gca,'FontSize',30);
    title(sprintf('Frequency= %d Hz',fo),'FontSize',40,'FontWeight','bold');
    xlabel('x (m)','FontSize',34); ylabel('y (m)','FontSize',34);
end
P=Pi; X=Xi; Y=Yi;




