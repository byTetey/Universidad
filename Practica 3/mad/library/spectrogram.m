function sg=spectrogram(x,fs,winms,shiftms)
%SPECTROGRAM Compute spectrogram for signal x using a window of size
% winms shifted by shiftms.
%  sg=spectrogram(x,fs,winms,shiftms)

if nargin<3
  shiftms=2.5;
end
if nargin<3
  winms=20;
end
if nargin<2
  fs=22050;
end
  
x=x(:)';    
winsamps=round((fs*winms)/1000);
shiftsamps=round((fs*shiftms)/1000);

halfwin=round(winsamps/2);
winsamps=2*halfwin+1;

centres=halfwin+1:shiftsamps:length(x)-halfwin;
fftsize=2.^ceil(log2(winsamps));
ham=madwindow(winsamps,'hamming')';
numframes=length(centres);

sg=zeros(numframes, round(fftsize/2)-1);
sgrang=2:round(fftsize/2);

for frm=1:numframes
  range=centres(frm)-halfwin:centres(frm)+halfwin;
  xfrag=x(range).*ham;
  xf=fft(xfrag,fftsize);
  if abs(xf(1)) > 0
    sg(frm,:)=log(abs(xf(sgrang)));
  end
end
  

