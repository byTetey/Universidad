function y = mdct(x)

x=x(:);

N=length(x);

n0 = N/4+1/2;
n=0:N-1;

wa = sin((n'+0.5)/N*pi);

y = zeros(N/2,1);

x = x .* exp(-j*2*pi*n'/2/N) .* wa;

X = fft(x);

y = real(X(1:N/2) .* exp(-j*2*pi*n0*(n(1:N/2)'+0.5)/N));

y=y(:);

