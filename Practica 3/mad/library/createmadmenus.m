function fig=createmadmenus(fig)
%CREATEMADMENUS creates standard help and quit menus

% part of the MAD v2.1 release
% MPC 11/6/99

ud=get(fig,'UserData');
app=ud.app;

%HELP
madhelp = uimenu('Parent',fig, 'Label','&Info', 'Accelerator','I');
uimenu('Parent',madhelp, 'Callback',[app ' help'],'Label',['help for ' app ' ...']);
uimenu('Parent',madhelp, 'Callback',[app ' aboutBox'],'Label','about ...');
uimenu('Parent',madhelp, 'Callback',[app ' bugReport'],'Label','bug report ...');

%QUIT
quitmenu = uimenu('Parent',fig,'Label','Quit');
uimenu('Parent',quitmenu,'Callback',[app ' reallyquit'],'Label','Really Quit?');	

version = uimenu('Parent',fig,'Label',['    MAD v' madversion]);
uimenu('Parent',version, 'Callback',[app ' localmadHomePage'],'Label','MAD home page (local version) ...');
uimenu('Parent',version, 'Callback',[app ' madHomePage'],'Label','MAD home page (remote version at Sheffield) ...');
