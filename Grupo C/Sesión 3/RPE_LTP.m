function [xr, error_pred_corto, error_pred_largo, N_T, b_T] = RPE_LTP(x, display)
%erbanga: sólo se devuelve la señal reconstruida

    % Filtro de preénfasis
    preenfasis = [1, -0.86];
    s = filter(preenfasis, 1, x);
    L= length(s);
    xr = zeros(length(x), 1);
    error_pred_corto = zeros(length(x),1);
    error_pred_largo = zeros(length(x),1);
    s=reshape(s,1,length(s));
    sr = zeros(1, length(s));
    % LPC con tramas de 160 muestras y ventana rectangular sin solapar
    ventana = ones(1,160);
    subtrama = 40;
    N_T = [];
    b_T= [];
   
    % Calcular el número de tramas
    % erbanga: he añadido +1 para procesar todas las muestras de x,
    % completando con ceros donde no hay muestras.
    num_frames = floor(length(s)/length(ventana))+1; 
    d = zeros(1, 40);
    dpp = zeros(1, 40);
    dp = zeros(1, 120);
    dpN = zeros(1,40);
    drpp=zeros(1,40);
    dr=zeros(1,40);
    drp = zeros(1,120);
    drpN = zeros(1,40);
    
    % Condiciones iniciales de los filtros
    zi_predictor_corto_analisis = [];
    zi_predictor_corto_sintesis = [];

    temp=[];
    posicion_actual = 1;
    for i = 1:num_frames;

        %erbanga: el desplazamiento de la ventana tiene que ser en este
        %caso igual a su longitud

        tramas = frames(s,i,length(ventana),ventana);
        temp=[temp tramas];
        
        % Cálculo de LPCs
        [ak, ~] = lpc(tramas, 10);        

        for t = 1:length(tramas)/subtrama; 

         % Obtener d[n] (error de predicción)
         subtrama_actual = tramas((t - 1) * subtrama + 1 : t * subtrama);
        
         [d, zi_predictor_corto_analisis] = filter(ak, 1, subtrama_actual ,zi_predictor_corto_analisis);
        % Concatenar cada d de subtrama 
        error_pred_corto(posicion_actual:posicion_actual+length(d)-1) = d;


        R=xcorr(d,dp);      
        % Encuentra el valor máximo y su posición en el intervalo [40, 120]
        intervalo = 40:120;
        [Rmax, pos] = max(R(intervalo));

        % El retardo N es la posición respecto al inicio de R
        N = pos +39;
        % Concatenar cada N de subtrama 
        N_T = [N_T, N];

        % Coger las 40 muestras de dp correspondientes al intervalo
        dpN = dp(end-N+1:end-N+40); 

        % Ganancia b
         b = Rmax/(sum(dpN.^2 )+eps);
         % Concatenar cada b de subtrama 
        b_T = [b_T, b];

         dpp = dpN.*b;
         e= d-dpp;
         % Concatenar cada e de subtrama 
        error_pred_largo(posicion_actual:posicion_actual+length(e)-1) = e;
    
if display

        figure(1)
            subplot(411),plot(0:39,d); xlabel('n');ylabel('d[n]'),grid,
            subplot(412),plot(-120:-1,dp); xlabel('n');ylabel('dp[n]'),grid,
            subplot(413),plot(0:39,dpp); xlabel('n');ylabel('dpp[n]'),grid,
            subplot(414),plot(0:39,e); xlabel('n');ylabel('e[n]'),grid,
            pause;

end

% Almacenar las 40 nuevas muestras de d en dp
        dp = [dp(41:end), d];        
    
% decod
        er = e;
        
        %erbanga: los pasos hay que hacerlos en el orden inverso al codificador       
        drpN = drp(end-N+1:end-N+40);
        drpp = drpN.*b;

        dr = drpp + er;

        % erbanga: gráficas de regalo
        if display

        figure(2)
            subplot(411),plot(0:39,er); xlabel('n');ylabel('er[n]'),grid,
            subplot(412),plot(-120:-1,drp); xlabel('n');ylabel('drp[n]'),grid,
            subplot(413),plot(0:39,drpp); xlabel('n');ylabel('drpp[n]'),grid,
            subplot(414),plot(0:39,dr); xlabel('n');ylabel('dr[n]'),grid,
            pause;

        end

        drp = [drp(41:end), dr];

        % FILTRO 1/A(z)
        [sr_subtrama ,zi_predictor_corto_sintesis] = filter(1,ak, dr, zi_predictor_corto_sintesis);
        % Concatenar cada sr de subtrama 
        sr(posicion_actual:posicion_actual+length(sr_subtrama)-1) = sr_subtrama;

        posicion_actual = posicion_actual + length(sr_subtrama);

        end
    end

    xr = filter(1, preenfasis, sr);
    xr=xr';
    %erbanga: longitud de la señal reconstruida ajustada a la original.
    xr=xr(1:length(x));
    
end