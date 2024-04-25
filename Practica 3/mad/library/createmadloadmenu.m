function fig=createmadloadmenu(fig)
%CREATEMADLOADMENU creates load/create menu for MAD demos

% Part of MAD V2.1
% MPC 11/6/99

ud=get(fig,'UserData');
app=ud.app;

filemenu = uimenu('Parent',fig,'Label','Signal');
uimenu('Parent',filemenu, 'Callback',[app ' load'], 'Label','load ...');
uimenu('Parent',filemenu, 'Callback',[app ' create'], 'Label','create ...');
