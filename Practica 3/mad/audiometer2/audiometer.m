function audiometer(action)
%audiometer A tool for teaching simple audiometer usage.
% NOTE: This tool requires calibration for each machine/headphone
%       combination. Without accurate calibration, the results obtained
%       will be nearly meaningless and certainly should not be
%       interpreted as accurate measurements of hearing level!

% Martin Cooke, September 1998
% Revised October 12 1998 to introduce equaliser (temporarily removed in v2.1)
% Revised January 14 1999 to incorporate calibration levels 
%
% Updated for MAD v2.1
% MPC 11/6/99

addpath ../library;
if nargin < 1
  action='init';
end

switch action
case 'init'
  f=findobj('Tag','audiometer_fig');
  if ~isempty(f)
    figure(f);
  else     
    audiometer_gui;
    ud=get(gcf,'UserData');
    ud.fs=44100;
    ud.duration=1000;
    ud.rampdur=25;
    
    rdur=round(ud.fs*ud.rampdur/1000);
    tdur=round(ud.fs*ud.duration/1000);
    
    % precompute tones    
    ud.env=madwindow(tdur,'hanning',rdur);   
    sdur=round(ud.fs*ud.duration/1000);
    ud.tones=zeros(length(ud.freqs),sdur);
    for f=1:length(ud.freqs)
      ud.tones(f,:)=ud.env.*sin(2*pi*(ud.freqs(f)/ud.fs)*(1:sdur));
    end    
    
    ud.lastfreq=getuicontrolvalue(ud.freqmenu,'num');
    ud.lastlevel=getuicontrolvalue(ud.levelSlider,'num');
    ud.lastear=getuicontrolvalue(ud.earmenu);
    ud.leftline=line('Parent',ud.resultsAxes,...
    'XData',ud.freqs,'YData',-500.*ones(size(ud.freqs)),...
    'LineStyle','none',...
    'Marker','<',...
    'MarkerSize',15,...
    'EraseMode','xor',...
    'Color','r');
    ud.rightline=line('Parent',ud.resultsAxes,...
    'XData',ud.freqs,'YData',-500.*ones(size(ud.freqs)),...
    'LineStyle','none',...
    'Marker','>',...
    'MarkerSize',15,...
    'EraseMode','xor',...
    'Color','g');      
    ud.relativelevels=zeros(size(ud.freqs));
    set(gcf,'UserData',ud);
    line('Parent',ud.resultsAxes,'XData',[250 8000],'YData',[20 20],...
    'LineWidth',2,'Color','b','LineStyle','-.');
  end

case 'playsound'
  ud=get(gcf,'UserData');
  ud.lastfreq=getuicontrolvalue(ud.freqmenu,'num');
  ud.lastlevel=getuicontrolvalue(ud.levelSlider,'num');
  ud.lastear=getuicontrolvalue(ud.earmenu);
  
  % subtract equal-loudness for this frequency
  newlevel = ud.lastlevel - ud.HLref + ud.calib(ud.freqs==ud.lastfreq);
  % and add 30 dB to offset the headphone attenuation
  newlevel = newlevel + 30;
  
  %t=tone(ud.lastfreq, newlevel, ud.duration,ud.env,ud.fs);
  t=ud.tones(ud.freqs==ud.lastfreq,:).*db2amp(newlevel,80);
  
  if strcmp(ud.lastear,'left')
    sound([t; zeros(1,length(t))]',ud.fs)
  else  
    sound([zeros(1,length(t)); t]',ud.fs)
  end
  set(ud.recordbutton,'Enable','on');
  set(gcf,'UserData',ud);
  
  
case 'levelChanged'
  ud=get(gcf,'UserData');
  set(ud.levelText,'String',getuicontrolvalue(ud.levelSlider,'int'));
  set(gcf,'UserData',ud);  
  
case 'save'
  ud=get(gcf,'UserData');
  [filename,pathname]=uiputfile('hearing_threshold.dat','Save file name');
  fid=fopen([pathname filename],'w');
  left=round(get(ud.leftline,'YData'));
  right=round(get(ud.rightline,'YData'));
  freqs=ud.freqs;
  fprintf(fid,'       LEFT RIGHT\n');
  for i=1:length(freqs)
    fprintf(fid,'%5d %5d %5d\n',freqs(i),left(i),right(i));
  end
  set(ud.savebutton,'Enable','off');
  fclose(fid)

case 'plot'
  ud=get(gcf,'UserData');  
  if strcmp(ud.lastear,'left')
    yd=get(ud.leftline,'YData');
    yd(ud.freqs==ud.lastfreq)=ud.lastlevel;
    if all(yd>-400)
      set(ud.leftline,'YData',yd,'LineStyle','-','LineWidth',2);
      set(ud.savebutton,'Enable','on');
    else
      set(ud.leftline,'YData',yd);
    end  
  else 		  
    yd=get(ud.rightline,'YData');
    yd(ud.freqs==ud.lastfreq)=ud.lastlevel;
    if all(yd>-400)
      set(ud.rightline,'YData',yd,'LineStyle','-','LineWidth',2);
      set(ud.savebutton,'Enable','on');
    else
      set(ud.rightline,'YData',yd);
    end
  end  
  set(ud.recordbutton,'Enable','off');
  set(gcf,'UserData',ud);

otherwise
  maduievent('audiometer',action);
  
end


