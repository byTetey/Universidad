function [sr, tr] = SumarRuido(s, t, desviacion)
    % Sumar ruido gaussiano a la señal compleja s(t)
    % s: Señal compleja original
    % t: Base de tiempos de la señal original
    % desviacion: Desviación típica (valor eficaz) del ruido a sumar

    % Generar ruido gaussiano independiente para la parte real e imaginaria
    ruido_real = desviacion * randn(size(s));
    ruido_imaginario = desviacion * randn(size(s));

    % Sumar ruido a la parte real e imaginaria de la señal
    sr = real(s) + ruido_real;
    si = imag(s) + ruido_imaginario;

    % Construir la señal compleja con ruido
    sr = sr + 1i * si;

    % Devolver la base de tiempos original
    tr = t;
end
