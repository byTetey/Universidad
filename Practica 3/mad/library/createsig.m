function [sig,fs,name]=createsig
%CREATESIG - UI for signal creation
%
% USAGE: [sig,fs,name]=createsig;
% where
%   sig is the signal
%   fs is the sampling frequency
%   name is the name

parentfig=figure('Visible','off');
udp.sig=[];
udp.name='none loaded';

set(parentfig,'UserData',udp);

f=findobj('Tag','createsignal_fig');
  if ~isempty(f)
    figure(f);
  else     
    createsignal_gui;
    ud=get(gcf,'UserData');
    ud.parent=parentfig;
    axes(ud.axes);
    ud.sigline=line([0 0],[0 0],'ButtonDownFcn','createsignal play');
    axes(ud.dftaxes);
    ud.dftline=line([0 0],[0 0],'ButtonDownFcn','createsignal play');
    set(gcf,'UserData',ud);
  end
  createsignal('reallyclear')
  uiwait
  
  udp=get(parentfig,'UserData');
  sig=udp.sig;
  if nargout > 1
    fs=udp.fs;
  end
  if nargout > 2  
    name=udp.name;
  end  
  delete(parentfig);
  
  
