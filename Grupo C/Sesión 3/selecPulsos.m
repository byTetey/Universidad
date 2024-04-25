function [er, posicion, amplitud] = selecPulsos(ew)

    % Genera las cuatro secuencias de excitacion candidatas
    cand = [ew(1:3:40-1); ew(2:3:40); ew(3:3:40); ew(4:3:40)];

    % Calcula la energia de cada secuencia candidata
    energias = sum(cand.^2, 1);

    % Encuentra la secuencia con la mayor energia
    [~, indice] = max(energias);
    candidata = cand(:, indice);

    % Construye la secuencia er(n) con inserciones de ceros
    factor_insercion = 2;  % Factor de insercion de ceros
    er = zeros(1, numel(candidata) * factor_insercion);
    er(1:factor_insercion:end) = candidata;

    % Devuelve la posición y la amplitud de la trama
    % Encuentra la posición y amplitud del pulso seleccionado
    [amplitud, posicion] = max(abs(candidata));

end
