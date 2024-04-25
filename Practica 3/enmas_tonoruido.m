function varargout = enmas_tonoruido(varargin)
% ENMAS_TONORUIDO M-file for enmas_tonoruido.fig
%      ENMAS_TONORUIDO, by itself, creates a new ENMAS_TONORUIDO or raises the existing
%      singleton*.
%
%      H = ENMAS_TONORUIDO returns the handle to a new ENMAS_TONORUIDO or the handle to
%      the existing singleton*.
%
%      ENMAS_TONORUIDO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENMAS_TONORUIDO.M with the given input arguments.
%
%      ENMAS_TONORUIDO('Property','Value',...) creates a new ENMAS_TONORUIDO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before enmas_tonoruido_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to enmas_tonoruido_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help enmas_tonoruido

% Last Modified by GUIDE v2.5 27-Oct-2008 13:01:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @enmas_tonoruido_OpeningFcn, ...
                   'gui_OutputFcn',  @enmas_tonoruido_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before enmas_tonoruido is made visible.
function enmas_tonoruido_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to enmas_tonoruido (see VARARGIN)

% Choose default command line output for enmas_tonoruido
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes enmas_tonoruido wait for user response (see UIRESUME)
% uiwait(handles.figure1);

load bandas_criticas.mat;

bc=bandas_criticas;

fs=16000;
N=fs*2;
bc1=10;
bc2=10;
a1=1e-3;
a2=1e-3;
t1=a1*cos(2*pi*bc(bc1,2)*(0:N)/fs);
nn=randn(1,N+1)*a2;
pares=[];



setappdata(gcf,'fs',fs);
setappdata(gcf,'N',N);
setappdata(gcf,'bc1',bc1);

setappdata(gcf,'a1',a1);
setappdata(gcf,'a2',a2);
setappdata(gcf,'t1',t1);
setappdata(gcf,'nn',nn);

setappdata(gcf,'bc',bc);
setappdata(gcf,'bc2',bc2);

set(handles.sliderA1,'Value',10*log10(a1^2/2));
set(handles.sliderA1,'Max',-30);
set(handles.sliderA1,'Min',-90);
set(handles.sliderF1,'Value',bc1);
set(handles.sliderA2,'Value',10*log10(a2^2/2));
set(handles.sliderA2,'Max',-30);
set(handles.sliderA2,'Min',-90);
set(handles.sliderbc,'Value',bc2);


set(handles.editA1,'String',num2str(10*log10(a1^2/2)));
set(handles.editF1,'String',num2str(bc1));
set(handles.editA2,'String',num2str(10*log10(a2^2/2)));
set(handles.editF2,'String',num2str(bc2));

set(handles.axes1,'XLim',[500 1900],'YLim',[-100 -20]);
set(handles.axes1,'XGrid','on','YGrid','on');

axes(handles.axes1); 
temptext1=text(bc(bc1,2),10*log10(a1^2/2),'\bullet','Color','r','FontSize',24,'HorizontalAlignment','center');
temptext2=rectangle('Position',[bc(bc2,3), -100, bc(bc2,4)-bc(bc2,3),10*log10(a2*a2/2)+100],'EdgeColor','b');
xlabel('Frecuencia (Hz)');ylabel('Potencia (dBW)');
setappdata(gcf,'temptext1',temptext1);
setappdata(gcf,'temptext2',temptext2);


% --- Outputs from this function are returned to the command line.
function varargout = enmas_tonoruido_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sliderF1_Callback(hObject, eventdata, handles)
% hObject    handle to sliderF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bc1=floor(get(hObject,'Value'));
if(bc1>12) bc1=12;
elseif (bc1<7) bc1=7;
end
set(handles.editF1,'String',num2str(bc1));
a1=getappdata(gcf,'a1');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');
bc=getappdata(gcf,'bc');
t1=a1*cos(2*pi*bc(bc1,2)*(0:N)/fs);
setappdata(gcf,'t1',t1);
setappdata(gcf,'bc1',bc1);
set(handles.editF1,'String',num2str(bc1));
%cla(handles.axes1);
temptext1=getappdata(gcf,'temptext1');

if(ishandle(temptext1)) delete(temptext1); end
temptext1=text(bc(bc1,2),10*log10(a1^2/2),'\bullet','Color','r','FontSize',24,'HorizontalAlignment','center');
setappdata(gcf,'temptext1',temptext1);



% --- Executes during object creation, after setting all properties.
function sliderF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editF1_Callback(hObject, eventdata, handles)
% hObject    handle to editF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editF1 as text
%        str2double(get(hObject,'String')) returns contents of editF1 as a double
f1=str2num(get(handles.editF1,'String'));
setappdata(gcf,'f1',f1);
set(handles.editF1,'String',num2str(f1));
set(handles.sliderF1,'Value',f1);

% --- Executes during object creation, after setting all properties.
function editF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editF2_Callback(hObject, eventdata, handles)
% hObject    handle to editF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editF2 as text
%        str2double(get(hObject,'String')) returns contents of editF2 as a double
f2=str2num(get(handles.editF2,'String'));
setappdata(gcf,'f2',f2);
set(hObject,'String',num2str(f2));
set(handles.sliderbc,'Value',f2);

% --- Executes during object creation, after setting all properties.
function editF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderA1_Callback(hObject, eventdata, handles)
% hObject    handle to sliderA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a1dB=get(hObject,'Value');
set(handles.editA1,'String',num2str(a1dB));
a1=sqrt(10^(a1dB/10)*2);
bc1=getappdata(gcf,'bc1');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');
bc=getappdata(gcf,'bc');
t1=a1*cos(2*pi*bc(bc1,2)*(0:N)/fs);
setappdata(gcf,'t1',t1);
setappdata(gcf,'a1',a1);
set(handles.editA1,'String',num2str(a1dB));
%cla(handles.axes1);
temptext1=getappdata(gcf,'temptext1');

if(ishandle(temptext1)) delete(temptext1); end
temptext1=text(bc(bc1,2),10*log10(a1^2/2),'\bullet','Color','r','FontSize',24,'HorizontalAlignment','center');
setappdata(gcf,'temptext1',temptext1);


% --- Executes during object creation, after setting all properties.
function sliderA1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderA2_Callback(hObject, eventdata, handles)
% hObject    handle to sliderA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a2dB=get(hObject,'Value');

set(handles.editA2,'String',num2str(a2dB));
a2=sqrt(10^(a2dB/10)*2);
bc2=getappdata(gcf,'bc2');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');

bc=getappdata(gcf,'bc');
n=randn(1,N);
filtro=fir1(200, bc(bc2,3:4)/(fs/2));
nn=conv(n,filtro);
nn=nn(101:end);
Pnn=(nn*nn')/length(nn);
nn=nn*sqrt(a2*a2/2/Pnn);

setappdata(gcf,'nn',nn);
setappdata(gcf,'a2',a2);
set(handles.editA2,'String',num2str(a2dB));
temptext2=getappdata(gcf,'temptext2');

if(ishandle(temptext2)) delete(temptext2); end
%temptext2=text(f2,10*log10(a2^2/2),'*','Color','g','FontSize',26,'HorizontalAlignment','center');
temptext2=rectangle('Position',[bc(bc2,3), -100, bc(bc2,4)-bc(bc2,3),10*log10(a2*a2/2)+100],'EdgeColor','b');
setappdata(gcf,'temptext2',temptext2);


% --- Executes during object creation, after setting all properties.
function sliderA2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editA1_Callback(hObject, eventdata, handles)
% hObject    handle to editA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editA1 as text
%        str2double(get(hObject,'String')) returns contents of editA1 as a double
a1dB=str2num(get(handles.editA1,'String'));
a1=sqrt(10^(a1dB/10)*2);
setappdata(gcf,'a1',a1);
set(handles.editA1,'String',num2str(a1dB));
set(handles.sliderA1,'Value',a1dB);

% --- Executes during object creation, after setting all properties.
function editA1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editA2_Callback(hObject, eventdata, handles)
% hObject    handle to editA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editA2 as text
%        str2double(get(hObject,'String')) returns contents of editA2 as a double
a2dB=str2num(get(handles.editA2,'String'));
a2=sqrt(10^(a2dB/10)*2);
setappdata(gcf,'a2',a2);
set(handles.editA2,'String',num2str(a2dB));
set(handles.sliderA2,'Value',a2dB);
temptext2=getappdata(gcf,'temptext2');
if(ishandle(temptext2)) delete(temptext2); end
temptext2=text(f2,10*log10(a2^2/2),'\bullet','Color','g','FontSize',24,'HorizontalAlignment','center');
setappdata(gcf,'temptext2',temptext2);


% --- Executes during object creation, after setting all properties.
function editA2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonStore.
function pushbuttonStore_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a2=getappdata(gcf,'a2');
f2=getappdata(gcf,'f2');
temptext2=getappdata(gcf,'temptext2');
frec=getappdata(gcf,'frec');
AdB=getappdata(gcf,'AdB');
hfrec=getappdata(gcf,'hfrec');
if(ishandle(temptext2)) delete(temptext2); end
temptext2=text(f2,10*log10(a2^2/2),'\bullet','Color','g','FontSize',24,'HorizontalAlignment','center');
setappdata(gcf,'temptext2',temptext2);
setappdata(gcf,'frec',[frec f2]);
setappdata(gcf,'AdB',[frec 10*log10(a2^2/2)]);
setappdata(gcf,'hfrec',[hfrec text(f2,10*log10(a2^2/2),'\bullet','Color','b','FontSize',24,'HorizontalAlignment','center')]);



% --- Executes on button press in pushbuttonP.
function pushbuttonP_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t1=getappdata(gcf,'t1');
fs=getappdata(gcf,'fs');
sound(t1,fs);

% --- Executes on button press in pushbuttonS.
function pushbuttonS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nn=getappdata(gcf,'nn');
fs=getappdata(gcf,'fs');
sound(nn,fs);

% --- Executes on button press in pushbuttonPS.
function pushbuttonPS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t1=getappdata(gcf,'t1');
nn=getappdata(gcf,'nn');
fs=getappdata(gcf,'fs');
sound(t1+nn(1:length(t1)),fs);

% --- Executes on slider movement.
function sliderbc_Callback(hObject, eventdata, handles)
% hObject    handle to sliderbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bc2=floor(get(hObject,'Value'));
set(handles.editF2,'String',num2str(bc2));
a2=getappdata(gcf,'a2');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');
%t2=a2*cos(2*pi*f2*(0:N)/fs);
bc=getappdata(gcf,'bc');
n=randn(1,N);
filtro=fir1(200, bc(bc2,3:4)/(fs/2));
nn=conv(n,filtro);
nn=nn(101:end);
Pnn=(nn*nn')/length(nn);
nn=nn*sqrt(a2*a2/2/Pnn);


setappdata(gcf,'nn',nn);
setappdata(gcf,'bc2',bc2);
set(handles.editF2,'String',num2str(bc2));
temptext2=getappdata(gcf,'temptext2');
if(ishandle(temptext2)) delete(temptext2); end
%temptext2=text(f2,10*log10(a2^2/2),'*','Color','g','FontSize',26,'HorizontalAlignment','center');
temptext2=rectangle('Position',[bc(bc2,3), -100, bc(bc2,4)-bc(bc2,3),10*log10(a2*a2/2)+100],'EdgeColor','b');
setappdata(gcf,'temptext2',temptext2);

% --- Executes during object creation, after setting all properties.
function sliderbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


