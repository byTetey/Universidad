function [y fsd]= diezmado(x,M,fs,orden_filtro)

%frec corte pi/M para pasar a disc div entre pi

b=fir1(orden_filtro,1/M);
y=filter(b,1,x);
y=y(1:M:end)
fsd=fs/M;
end

