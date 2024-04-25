function v=getuicontrolvalue(p,format)

if nargin < 2
  format = 'string';
end
 
uitype=get(p,'Style');
switch uitype
  case 'text'
    v=deblank(get(p,'String'));
  case 'checkbox'
    v=get(p,'Value');  
  case 'popupmenu'
    val=get(p,'Value');
    str=get(p,'String');
    if iscellstr(str)
      v=deblank(str{val,:});
    else  
      v=deblank(str(val,:));  
    end  
    %v=str(val,:);
  case 'listbox'
    val=get(p,'Value');
    str=get(p,'String');
    if iscellstr(str)
      v=deblank(str{val,:});
    else  
      v=deblank(str(val,:));  
    end    
  case 'edit'
    v=get(p,'String');
  case 'slider'
    v=deblank(num2str(get(p,'Value')));
  otherwise
    disp(['Cannot find uicontrol of style ' uitype]);
end
if strcmp(format,'num')  
  v=str2num(v);
elseif strcmp(format,'int')
  v=round(str2num(v));
end  
