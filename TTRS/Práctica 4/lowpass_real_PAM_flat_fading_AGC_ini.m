cons=get_param([bdroot '/Global'],'constellation');
Rb=get_param([bdroot '/Global'],'Rb');
set_param([bdroot '/PAM'],'cnstl',cons);
set_param([bdroot '/Decision-Decod'],'SigCon',cons);

L=length(eval(cons));
nbits=log2(L);
Es=sum(abs(eval(cons)).^2)/L;

d=get_param([bdroot '/Global'],'NoiseVar');
set_param([bdroot '/AWGN'],'d',d);

N=get_param([bdroot '/Raised Cosine Transmit Filter'],'N');
set_param([bdroot '/Raised Cosine Receive Filter'],'N',N);
set_param([bdroot '/Downsample'],'N',N);
set_param([bdroot '/AGC'],'DesiredOutputPower',num2str(Es/eval(N)));


Tb=1/eval(Rb);
set_param([bdroot '/Bits/Bits'],'Ts',num2str(Tb));

T=nbits*Tb;
Tu=T/eval(N);
fu=1/Tu;
