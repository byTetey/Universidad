function fig=createmadfig(app)
%CREATEMADFIG creates MAD figure window and sets common
% interface style parameters

% Version 2.1
% MPC 11/6/99

% NOTE: the position coords below have been tested on the following machines:
%   MAC  (MPC 11/6/99)
%   SOL2 (MPC 4/8/99)
%   WIN  (MPC 4/8/99)

switch computer
case 'MAC2'
  pos=[0 0 1 1];
case 'SOL2'
  pos=[0.02 0.1 0.96 0.83];
case 'PCWIN'
   %pos=[0.01 0.05 0.98 0.85];
   pos=[0.0 0.0 0.93 0.94];
otherwise
  pos=[0 0 1 1];
end

ud.app=app;
fig = figure('Units','normalized',...
        'Position',pos,...
        'Color',[0.8 0.8 0.8],...
        'Menubar','none',...   
        'Name',app, ...
        'NumberTitle','off',...
        'CloseRequestFcn',[app ' close'],...
        'BackingStore','on',...
        'Tag',[app '_fig'],...
        'UserData',ud);           

switch computer
case 'MAC2'
set(fig,'DefaultAxesFontSize',14);
set(fig,'DefaultUIControlFontSize',14);
case 'SOL2'
set(fig,'DefaultAxesFontSize',14);
set(fig,'DefaultUIControlFontSize',14);
case 'PCWIN'
set(fig,'DefaultAxesFontSize',14);
set(fig,'DefaultUIControlFontSize',14);
otherwise
set(fig,'DefaultAxesFontSize',14);
set(fig,'DefaultUIControlFontSize',14);
end

set(fig,'DefaultAxesUnits','normal');
set(fig,'DefaultUicontrolUnits','normal');
set(fig,'DefaultUicontrolBackgroundColor',get(fig,'Color'));
set(fig,'UserData',ud);
