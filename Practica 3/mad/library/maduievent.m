function maduievent(application,action)
%MADUIEVENT function to handle generic user interface events
% in the MAD package.

% created 24/4/99 by Martin

switch action

case 'close'
  if strcmp(questdlg('Are you sure you want to quit?'),'Yes')
    eval([application ' reallyquit']);
  end
  
case 'reallyquit'
  delete(get(0,'CurrentFigure'));
  
case 'aboutBox'
  helpwin(application);
  
case 'help'
  web(['file:' madroot '/' application '/' application '.htm']);
 
case 'localmadHomePage'
  web(['file:' madroot '/docs/mad.htm']);
 
case 'madHomePage'
  web ('http://www.dcs.shef.ac.uk/~martin/MAD/docs/mad.htm');
    
case 'bugReport'
  web ('mailto:m.cooke@dcs.shef.ac.uk');
  
otherwise
  disp([application ': unknown action ''' action ''''])
  
end
