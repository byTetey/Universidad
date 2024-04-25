function s=chromaticscale(n)
%CHROMATICSCALE generate nth chromatic scale
%
%  s=chromaticScale(n)
%

% hey, how about an ERB-rate tuned instrument instead?

% find lowest C
A0=6.875;
s=logspace(log10(A0),log10(2*A0),13);
C0=s(4);

C=power(2,n-1)*C0;
s=logspace(log10(C),log10(2*C),13);
