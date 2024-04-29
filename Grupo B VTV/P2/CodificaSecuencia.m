function SymbolStream = CodificaSecuencia(bitstream)
    %Verificar si la longitud del vector de bits es par
    if mod(length(bitstream),2) ~= 0
        error('El número de elementos debe ser par');
    end
    
    % Inicializar la secuencia de símbolos complejos
    SymbolStream = zeros(1,length(bitstream)/2);

    % Iterar sobre los pares de bits
    for i = 1:2:length(bitstream)
        % Obtener el par de bits actual
        bit1 = bitstream(i);
        bit2 = bitstream(i+1);

        % Convertir el par de bits a un símbolo QPSK
        if bit1 == 0 && bit2 == 0
            SymbolStream((i+1)/2) = 1;
        elseif bit1 == 1 && bit2 == 0
            SymbolStream((i+1)/2) = 1i;
        elseif bit1 == 0 && bit2 == 1
            SymbolStream((i+1)/2) = -1i;
        elseif bit1 == 1 && bit2 == 1
            SymbolStream((i+1)/2) = -1;
        else
            error('Secuencia binaria no válida');
        end
    end         
end