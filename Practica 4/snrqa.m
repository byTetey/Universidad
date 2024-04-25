function [SNRQ ,ejex]=snrqa(A);
xsc=1;
x=cos(2*pi*20/8000*(1:1000));
i=0;
SNRQ=[];
ejex=[];
warning off MATLAB:divideByZero
for a=1e-3:0.01:1.5
    i=i+1;
    s=a*x;
    
    if(A) As=compand(s, A, xsc, 'A/compressor');
    else As=s;
    end
    
    qAs=quantize(As,8);
    
    if(A) y=compand(qAs, A, xsc, 'A/expander');
    else y=qAs;
    end;
    
    SNRQ=[SNRQ 10*log10(var(s)/var(y-s))];
    ejex=[ejex 20*log10(a/1)];
end
end



    
    