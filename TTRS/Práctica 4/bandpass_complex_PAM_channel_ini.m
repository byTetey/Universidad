cons=get_param([bdroot '/Global'],'constellation');
Rb=get_param([bdroot '/Global'],'Rb');
fc=get_param([bdroot '/Global'],'fc');
set_param([bdroot '/PAM'],'cnstl',cons);
set_param([bdroot '/Decision-Decod'],'SigCon',cons);
set_param([bdroot '/Generador'],'frec',fc);

nbits=log2(length(eval(cons)));

d=get_param([bdroot '/Global'],'NoiseVar');
set_param([bdroot '/AWGN'],'d',d);

N=get_param([bdroot '/Raised Cosine Transmit Filter'],'N');
set_param([bdroot '/Raised Cosine Receive Filter'],'N',N);
%set_param([bdroot '/Downsample'],'N',N);

%bb=eval(N)*log2(length(eval(cons)))

Tb=1/eval(Rb);
set_param([bdroot '/Bits/Bits'],'Ts',num2str(Tb));

T=nbits*Tb;
Tu=T/eval(N);
fu=1/Tu;

channel=get_param([bdroot '/Global'],'channel');
CFreqD=eval(get_param([bdroot '/Global'],'CFreqD'));
CPhasD=eval(get_param([bdroot '/Global'],'CPhasD'));
SPerD=eval(get_param([bdroot '/Global'],'SPerD'));
SPhasD=eval(get_param([bdroot '/Global'],'SPhasD'));

fc=eval(get_param([bdroot '/Generador'],'frec'));
fc=fc*(1+CFreqD/100);
nN=round(eval(N)*(1+SPerD/100));
pN=round(eval(N)*(1-SPhasD/100));
pN=mod(pN,eval(N));

set_param([bdroot '/Discrete FIR Filter'], 'Coefficients',channel);
set_param([bdroot '/Generador1'],'frec',num2str(fc));
set_param([bdroot '/Generador1'],'desfase',num2str(CPhasD));
set_param([bdroot '/Downsample'],'N',num2str(nN));
set_param([bdroot '/Downsample'],'phase',num2str(pN));

M=eval(N);

ch1=[1 zeros(1,M-1) 0.28 zeros(1,floor(2.3*M)) 0.11];    % weak ISI   

ch2=[1 zeros(1,M-1) 0.28 zeros(1,floor(1.8*M)) 0.44]; % strong ISI   

