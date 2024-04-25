function [xr,error_pred_corto, error_pred_largo, delay, gain] = RPE_LTP_pulsos(x, display)
    



    error_pred_corto = zeros(length(x),1);
    error_pred_largo = zeros(length(x),1);
    delay= [];
    gain= [];

    % Filtro de preénfasis
    preenfasis = [1, -0.86];
    s = filter(preenfasis, 1, x);
    s=reshape(s,1,length(s));

    sr = zeros(1, length(s));
    e = zeros(1,40);
    er = zeros(1,40);
    ew= zeros(1,40);

    % LPC con tramas de 160 muestras y ventana rectangular sin solapar
    ventana = ones(1,160);
    subtrama = 40;

    xr = zeros(length(x), 1);
    % Calcular el número de tramas
    num_frames = floor(length(s)/length(ventana)+1);

    d = zeros(1, 40);
    dpp = zeros(1, 40);
    dp = zeros(1, 120);
    dpN = zeros(1,40);
    drpN = zeros(1,40);
    drp = zeros(1,120);
    dr = zeros(1,40);

    % Condiciones iniciales de los filtros
    zi_predictor_corto_analisis = [];
    zi_predictor_corto_sintesis = [];
    posicion_actual=1;
    temp=[];

    for i = 1:num_frames

        tramas = frames(s,i,length(ventana),ventana);
        temp=[temp tramas];

        % Cálculo de LPCs
        [ak, ~] = lpc(tramas, 10);

        for t = 1:length(tramas)/subtrama
        
        % Obtener d[n] (error de predicción)
         subtrama_actual = tramas((t - 1) * subtrama + 1 : t * subtrama);
         [d, zi_predictor_corto_analisis] = filter(ak, 1, subtrama_actual ,zi_predictor_corto_analisis);
         error_pred_corto(posicion_actual:posicion_actual+length(d)-1) = d;
        R=xcorr(d,dp);      % AMBOS DIMENSION 1X120
        % Encuentra el valor máximo y su posición en el intervalo [40, 120]
        intervalo = 40:120;
        [Rmax, pos] = max(R(intervalo));

        % El retardo N es la posición respecto al inicio de R
        N = pos +39;
        delay= [delay, N];
        % Calcula el vector dpN con el retardo N
         dpN = dp(end-N+1:end-N+40); 

        % Ganancia b
         b = Rmax/(sum(dpN.^2 )+eps);
         gain=[gain, b];
         dpp = dpN.*b;

         e=d-dpp;
         error_pred_largo(posicion_actual:posicion_actual+length(e)-1) = e;

    if display

        figure(1)
            subplot(411),plot(0:39,d); xlabel('n');ylabel('d[n]'),grid,
            subplot(412),plot(-120:-1,dp); xlabel('n');ylabel('dp[n]'),grid,
            subplot(413),plot(0:39,dpp); xlabel('n');ylabel('dpp[n]'),grid,
            subplot(414),plot(0:39,e); xlabel('n');ylabel('e[n]'),grid,
            pause;

    end  

    w = [-134, -374, 0, 2054, 5741, 8192, 5741, 2054, 0, -374, -134] / power(2, 13);
    ew = conv(e, w, 'same');
    cand = [ew(1:3:40-1); ew(2:3:40); ew(3:3:40); ew(4:3:40)];
    energies = sum(cand.^2, 1);
    [~, index] = max(energies);
       if(index==1)
        er(1:3:40-1) = ew(1:3:40-1);
       elseif(index==2)
        er(2:3:40) = ew(2:3:40);
        elseif(index==3)
        er(3:3:40) =  ew(3:3:40);

       else er(4:3:40) = ew(4:3:40);
       

 % Almacenar resultado en dp
 
 dp = [dp(41:end), dpp+er];

% decod     
        
        %erbanga: los pasos hay que hacerlos en el orden inverso al codificador       
       drpN = drp(end-N+1:end-N+40);
       dpp = drpN.*b;

        dr = dpp + er;

        % erbanga: gráficas de regalo
        if display

        figure(2)
            subplot(411),plot(0:39,er); xlabel('n');ylabel('er[n]'),grid,
            subplot(412),plot(-120:-1,drp); xlabel('n');ylabel('drp[n]'),grid,
            subplot(413),plot(0:39,dpp); xlabel('n');ylabel('dpp[n]'),grid,
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