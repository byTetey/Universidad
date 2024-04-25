function [signal,srate,name]=createsignal(action)
%CREATESIGNAL user-controlled signal generation

% created on 24/4/99 by Martin


switch action

case 'handleradio'
  ud=get(gcf,'UserData');
  rbs=findobj(gcf,'Tag','sigradio');
  set(rbs,'Value',0);
  set(gcbo,'Value',1);
  ud.lastradio=gcbo;
  set(findobj(gcf,'Tag','addButton'),'Enable','on');
  set(gcf,'UserData',ud);
  
case 'clear'
  %if strcmp(questdlg('Are you sure you want to clear?'),'Yes')
    createsignal 'reallyclear'
  %end

case 'reallyclear'  
    ud=get(gcf,'UserData');
    ud.sig=0;
    ud.nosignal=1;
    ud.name=[];
    set([ud.fs ud.dur],'Enable','on');
    set(findobj(gcf,'Tag','saveButton'),'Enable','off');
    set(findobj(gcf,'Tag','doneButton'),'Enable','off');
    set(findobj(gcf,'Tag','clearButton'),'Enable','off');
    set(gcf,'name','');
    set(gcf,'UserData',ud);
    createsignal 'display'   

case 'add'
  % find what we're meant to create
  ud=get(gcf,'UserData');
  if ud.nosignal
    ud.nosignal=0;
    set([ud.fs ud.dur],'Enable','off');
    set(findobj(gcf,'Tag','saveButton'),'Enable','on');
    set(findobj(gcf,'Tag','doneButton'),'Enable','on');
    set(findobj(gcf,'Tag','clearButton'),'Enable','on');
  end  
  durms=getuicontrolvalue(ud.dur,'num');
  fs=getuicontrolvalue(ud.fs,'num');
  dursamps=round(fs*durms/1000);
  rampsamps=round(fs*getuicontrolvalue(ud.rampms,'num')/1000);

  sigtype=get(ud.lastradio,'String');
  if isempty(ud.name)
    ud.name=sigtype;
  else  
    ud.name=[ud.name '+' sigtype];
  end  
  switch sigtype
  case 'tone'
    freq=getuicontrolvalue(ud.freq,'num');
    phase=getuicontrolvalue(ud.phase,'num');
    level=dB2amp(getuicontrolvalue(ud.freqlevel,'num'));
    sig=localtone(freq,dursamps,level,fs);
  case 'noise'
    level=dB2amp(getuicontrolvalue(ud.noiselevel,'num'));
    sig=level.*rand(1,dursamps);
  case 'impulses'
    first=round(fs*getuicontrolvalue(ud.firstimpulse,'num')/1000);
    rep=round(fs*getuicontrolvalue(ud.repeatrate,'num')/1000);
    level=dB2amp(getuicontrolvalue(ud.impulseslevel,'num'));
    sig=zeros(1,dursamps);
    sig(first:rep:dursamps)=level;    
    
  case 'harmonics'
    fundamental=getuicontrolvalue(ud.fundamental,'num');
    number=getuicontrolvalue(ud.number,'num');
    level=dB2amp(getuicontrolvalue(ud.harmonicslevel,'num'));
    sig=zeros(1,dursamps);
    for i=1:number
      sig=sig+localtone(i*fundamental,dursamps,level,fs);
    end  
    
  case 'resonance'
    freq=getuicontrolvalue(ud.resfreq,'num');
    bw=getuicontrolvalue(ud.resbw,'num');
    level=dB2amp(getuicontrolvalue(ud.resonancelevel,'num'));
    % work out z plane locations of things
    r=exp(-pi*bw/fs);
    f=2*pi*freq/fs;
    % convert to transfer function form
    rc=r*cos(f);
    rs=r*sin(f);
    [num,den]=zp2tf([],[rc+j*rs; rc-j*rs],1);
    sig=zeros(1,dursamps);
    sig(1)=level;
    sig=filter(num,den,sig);
 
otherwise
  disp(['unknown option ' get(ud.lastradio,'String')])  
end
% change level
% add ramp if required
if rampsamps > 0
    % generate half hanning ramp
    if rampsamps*2 > dursamps
      rampsamps=round(dursamps/2);
      set(ud.rampms,'String',num2str(round(1000*rampsamps/fs)));
    end      
    t=0:rampsamps-1; c=pi/(rampsamps-1);
    ham=0.5-0.5*cos(c*t);
    %hwin=round(rampsamps/2);
    hwin=rampsamps;
    ramp=ones(1,dursamps);
    ramp(1:hwin)=ham(1:hwin);
    ramp(dursamps-hwin+1:dursamps)=fliplr(ham(1:hwin));
    sig=sig.*ramp;
end  
if isfield(ud,'sig')
  ud.sig=ud.sig+sig;
else
  ud.sig=sig;
end 
set(gcf,'Name',ud.name);
set(gcf,'UserData',ud);
createsignal 'display'


case 'display'
  ud=get(gcf,'UserData');
  set(ud.sigline,'XData',1:length(ud.sig),'YData',ud.sig);
  dft=fft(ud.sig); 
  dft=dft(2:round(length(dft)/2));
  set(ud.dftline,'XData',1:length(dft),'YData',20*log10(abs(dft)));
  set(gcf,'UserData',ud);
  
case 'play'
  ud=get(gcf,'UserData');
  soundsc(ud.sig,getuicontrolvalue(ud.fs,'num'));
  set(gcf,'UserData',ud);
  
case 'save'
	ud=get(gcf,'UserData');
	[f,p] = uiputfile(['createdsig.au'],'Save to file');
	if f
    s=ud.sig;
    s=s/max(abs(s));
	  auwrite(s,ud.fs,[p f]);
  end

case 'done'
  ud=get(gcf,'UserData');
  udp=get(ud.parent,'UserData');
  udp.sig=ud.sig;
  udp.name=get(gcf,'Name');
  udp.fs=getuicontrolvalue(ud.fs,'num');
  set(ud.parent,'UserData',udp);  
  delete(gcf)
  
case 'cancel'
  if strcmp(questdlg('Are you sure you want to cancel?'),'Yes')
  ud=get(gcf,'UserData');
  udp=get(ud.parent,'UserData');
  udp.sig=[];
  udp.name=get(gcf,'Name');
  udp.fs=getuicontrolvalue(ud.fs,'num');
  set(ud.parent,'UserData',udp);  
  delete(gcf)
  end

otherwise
  maduievent('createsignal',action);
  
  end  
  
  function x=localtone(freq,dursamps,level,fs)
  x=level.*sin(2*pi*(freq/fs)*(1:dursamps));

  function a=dB2amp(d)
  a=power(10,d/20);
