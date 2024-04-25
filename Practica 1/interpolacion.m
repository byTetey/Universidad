function [y fsi] = interpolacion(x, L, fs, orden)
    y= zeros(1, L*length(x));   % entre cada dos muestras queda un cero
    y(1:L:end) =x;
    b=fir1(orden,1/L)*L;    % ganancia L
    y=filter(b,1,y);
    fsi=L*fs;



