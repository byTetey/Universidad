function bitstream = CreaSecuencia(longitud)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                             %
% Crea una secuencia aleatoria de bits de la  %
% longitud dada.                              %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:longitud,
    aux = rand; % Numero aleatorio
    if (rand>0.5)
        % mitad de arriba ==> 1
        bitstream(i) = 1;
    else
        % mitad de abajo ==> 0
        bitstream(i) = 0;
    end
end
