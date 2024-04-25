function [SNRQ ,ejex]=snrqmu(mu);
xsc=1;
x=cos(2*pi*20/8000*(1:1000));
i=0;
SNRQ=[];
ejex=[];
warning off MATLAB:divideByZero
for a=1e-3:0.01:1.5
    i=i+1;
    s=a*x;
    
    if(mu) mus=compand(s, mu, xsc, 'mu/compressor');
    else mus=s;
    end
    % si mu=0 es similar a aplicar un cuantificador uniforme (lo que seria un midriser)
    qmus=quantize(mus,8);
    
    if(mu) y=compand(qmus, mu, xsc, 'mu/expander');
    else y=qmus;
    end;
    
    SNRQ=[SNRQ 10*log10(var(s)/var(y-s))];
    ejex=[ejex 20*log10(a/1)];      % a=amplitud, 1= valor de sobrecarga
end
end



    
    