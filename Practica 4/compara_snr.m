[SNRQ255,ejex]=snrqmu(255);
[SNRQ0,ejex]=snrqmu(0); % ESTO VENDRÍA A SER CUANTIFICAICIÓN MIDRISER
[SNRQ87,ejex]=snrqa(87.6);

hold off;
plot(ejex,SNRQ255,'b',ejex,SNRQ0,'r',ejex,SNRQ87,'g');
title('SNRQ uniforme vs no uniforme');
xlabel('20*log10(a/xsc)');
ylabel('SNRQ (dB)');
grid






    
    