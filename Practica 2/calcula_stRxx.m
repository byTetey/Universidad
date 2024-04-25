
[speech,fs]=audioread('paulo8khz.wav');
speech=reshape(speech,1,length(speech));

N=281; window_shift=160;

window=hamming(N)';

number_of_frames=floor(length(speech)/window_shift);
[Rxx m]=stRxx(speech,[1:number_of_frames],window, window_shift);
% rxx es la funcion de autocorrelacion del segmento enventanado

% Ejemplo: Gráfica de una trama de voz y su función de autocorrelación
temp=size(Rxx);
temp=floor(temp(2)/2);
k=-temp:temp;

ind_trama=51; %Representamos la función de autocorrelación de la trama indicada 
              %por este índice.

subplot(211),plot(1:N,speech(m(ind_trama)-N+1:m(ind_trama)));axis tight;
subplot(212),plot(k,Rxx(ind_trama,:));axis tight;


% para observar la autocorrelacion de un segmento marcamos el numero de
% muestra con plot(speech) y lo dividimos entre el desplazamiento de la
% ventana, que en este caso es 160

% POR EJEMPLO HACIENDO ESTO ULTIMO QUE DIJO ÉL EN EL CENTRO SALE:
% 16232/160=101.45, esto se asigna al ind_trama para calcular la
% autocorrelacion de dicha trama
