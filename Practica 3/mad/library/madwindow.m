function w=madwindow(len,wtype,uplen)
%MADWINDOW General-purpose window shape generator
% which can be used to produce rectangular, hamming, etc
% windows, or can be used for on/off ramps by specifying
% an optional 3rd argument.
%
% USAGE
%
% w=madwindow(len,wtype,uplen)
%
% where:
%   len is the total window length (in samples)
%   wtype (optional) is the type of window. Currently available types are
%      'rectangular'     (default)
%      'hamming'
%      'hanning'
%      'triangular'
%   uplen is the length of the onset or offset portion
%     if twice uplen is greater then len, uplen is reduced

% MPC 14/6/99 Bergen
% Altered name to avoid conflict with window function in V6

if nargin < 3
  uplen=round(len/2);
  n=len;
else
  if 2*uplen > len
    uplen=round(len/2);
  end  
  n=2*uplen;
end  
if nargin < 2
  wtype='rectangular';
end

% generate window of length n
switch wtype
case 'rectangular'
  w = ones(n,1);
case 'hamming'
  w = .54 - .46*cos(2*pi*(0:n-1)'/(n-1));
case 'hanning'
  w = .5*(1 - cos(2*pi*(1:n)'/(n+1)));
case 'triangular'
  halflen=round(n/2);
  if 2*halflen > n
    w(1:halflen)=linspace(0,1,halflen);
    w(halflen:n)=linspace(1,0,halflen);
  else
    w(1:halflen)=linspace(0,1,halflen);
    w(halflen:n)=linspace(1,0,halflen+1);
  end
  w=w';
  
otherwise
  warndlg(['Window type ' wtype ' is not currently supported'])
end

if nargin == 3
  r = ones(1,len);
  r(1:uplen)=w(1:uplen);
  r(len-uplen+1:len)=w(uplen+1:n);
  w=r;
end 
