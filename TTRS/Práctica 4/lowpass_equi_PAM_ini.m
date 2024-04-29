cons=get_param([bdroot '/Global'],'constellation');
Rb=get_param([bdroot '/Global'],'Rb');
set_param([bdroot '/PAM'],'cnstl',cons);
set_param([bdroot '/Decision-Decod'],'SigCon',cons);


d=get_param([bdroot '/Global'],'NoiseVar');
set_param([bdroot '/AWGN-I'],'d',d);
set_param([bdroot '/AWGN-Q'],'d',d);

N=get_param([bdroot '/Raised Cosine Transmit Filter'],'N');
set_param([bdroot '/AWGN-I'],'sampPerFrame',N);
set_param([bdroot '/AWGN-Q'],'sampPerFrame',N);
set_param([bdroot '/Downsample'],'N',N);

bb=eval(N)*log2(length(eval(cons)))
set_param([bdroot '/Frame Bits/Buffer'],'N',num2str(bb));

Tb=1/eval(Rb);
set_param([bdroot '/Bits/Bits'],'Ts',num2str(Tb));



