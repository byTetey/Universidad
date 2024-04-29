cons=get_param([bdroot '/Global'],'constellation');
Rb=get_param([bdroot '/Global'],'Rb');
set_param([bdroot '/PAM'],'cnstl',cons);
set_param([bdroot '/Decision-Decod'],'SigCon',cons);

nbits=log2(length(eval(cons)));

d=get_param([bdroot '/Global'],'NoiseVar');
set_param([bdroot '/AWGN'],'d',d);

N=get_param([bdroot '/Raised Cosine Transmit Filter'],'N');
set_param([bdroot '/Raised Cosine Receive Filter'],'N',N);
set_param([bdroot '/Downsample'],'N',N);

%bb=eval(N)*log2(length(eval(cons)))

Tb=1/eval(Rb);
set_param([bdroot '/Bits/Bits'],'Ts',num2str(Tb));

T=nbits*Tb;
Tu=T/eval(N);
fu=1/Tu;
