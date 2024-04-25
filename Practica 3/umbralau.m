function varargout = umbralau(varargin)
% UMBRALAU M-file for umbralau.fig
%      UMBRALAU, by itself, creates a new UMBRALAU or raises the existing
%      singleton*.
%
%      H = UMBRALAU returns the handle to a new UMBRALAU or the handle to
%      the existing singleton*.
%
%      UMBRALAU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UMBRALAU.M with the given input arguments.
%
%      UMBRALAU('Property','Value',...) creates a new UMBRALAU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before umbralau_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to umbralau_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help umbralau

% Last Modified by GUIDE v2.5 21-Oct-2008 17:49:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @umbralau_OpeningFcn, ...
                   'gui_OutputFcn',  @umbralau_OutputFcn, ...
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


% --- Executes just before umbralau is made visible.
function umbralau_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to umbralau (see VARARGIN)

% Choose default command line output for umbralau
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes umbralau wait for user response (see UIRESUME)
% uiwait(handles.figure1);

fs=32000;
N=fs*2;

f1=1200;
f2=1400;
a1=1e-3
a2=1e-3;
t1=a1*cos(2*pi*f1*(0:N)*fs);
t2=a2*cos(2*pi*f2*(0:N)*fs);
pares=[];

setappdata(gcf,'fs',fs);
setappdata(gcf,'N',N);
setappdata(gcf,'f1',f1);
setappdata(gcf,'f2',f2);
setappdata(gcf,'a1',a1);
setappdata(gcf,'a2',a2);
setappdata(gcf,'t1',t1);
setappdata(gcf,'t2',t2);



set(handles.sliderA2,'Value',10*log10(a2^2/2));
set(handles.sliderA2,'Max',-30);
set(handles.sliderA2,'Min',-90);
set(handles.sliderF2,'Value',f2);


set(handles.editA2,'String',num2str(10*log10(a2^2/2)));
set(handles.editF2,'String',num2str(f2));

set(handles.axes1,'XLim',[100 16000],'YLim',[-100 -20]);
set(handles.axes1,'XGrid','on','YGrid','on');

axes(handles.axes1); 
%text(f1,10*log10(a1^2/2),'\bullet','Color','r','FontSize',24,'HorizontalAlignment','center');
temptext2=text(log10(f2),10*log10(a2^2/2),'\bullet','Color','g','FontSize',24,'HorizontalAlignment','center');

% --- Outputs from this function are returned to the command line.
function varargout = umbralau_OutputFcn(hObject, eventdata, handles) 
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
f1=floor(get(hObject,'Value')+0.5);
set(handles.editF1,'String',num2str(f1));
a1=getappdata(gcf,'a1');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');
t1=a1*cos(2*pi*f1*(0:N)/fs);
setappdata(gcf,'t1',t1);
setappdata(gcf,'f1',f1);
set(handles.editF1,'String',num2str(f1));
cla(handles.axes1);
text(f1,10*log10(a1^2/2),'\bullet','Color','r','FontSize',24,'HorizontalAlignment','center');

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
a2=getappdata(gcf,'a2');
setappdata(gcf,'f2',f2);
set(hObject,'String',num2str(f2));
set(handles.sliderF2,'Value',f2);
temptext2=getappdata(gcf,'temptext2');
if(ishandle(temptext2)) delete(temptext2); end
temptext2=text(f2,10*log10(a2^2/2),'\bullet','Color','g','FontSize',24,'HorizontalAlignment','center');
setappdata(gcf,'temptext2',temptext2);

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
f1=getappdata(gcf,'f1');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');
t1=a1*cos(2*pi*f1*(0:N)/fs);
setappdata(gcf,'t1',t1);
setappdata(gcf,'a1',a1);
set(handles.editA1,'String',num2str(a1dB));
cla(handles.axes1);
text(f1,10*log10(a1^2/2),'\bullet','Color','r','FontSize',24,'HorizontalAlignment','center');

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
f2=getappdata(gcf,'f2');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');
t2=a2*cos(2*pi*f2*(0:N)/fs);
setappdata(gcf,'t2',t2);
setappdata(gcf,'a2',a2);
set(handles.editA2,'String',num2str(a2dB));
temptext2=getappdata(gcf,'temptext2');
if(ishandle(temptext2)) delete(temptext2); end
temptext2=text(f2,10*log10(a2^2/2),'\bullet','Color','g','FontSize',24,'HorizontalAlignment','center');
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
temptext2=text(log10(f2),10*log10(a2^2/2),'\bullet','Color','g','FontSize',24,'HorizontalAlignment','center');
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
t2=getappdata(gcf,'t2');
fs=getappdata(gcf,'fs');
sound(t2,fs);

% --- Executes on button press in pushbuttonPS.
function pushbuttonPS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t1=getappdata(gcf,'t1');
t2=getappdata(gcf,'t2');
fs=getappdata(gcf,'fs');
sound(t1+t2,fs);

% --- Executes on slider movement.
function sliderF2_Callback(hObject, eventdata, handles)
% hObject    handle to sliderF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
f2=floor(get(hObject,'Value')+0.5);
set(handles.editF2,'String',num2str(f2));
a2=getappdata(gcf,'a2');
N=getappdata(gcf,'N');
fs=getappdata(gcf,'fs');
t2=a2*cos(2*pi*f2*(0:N)/fs);
setappdata(gcf,'t2',t2);
setappdata(gcf,'f2',f2);
set(handles.editF2,'String',num2str(f2));
temptext2=getappdata(gcf,'temptext2');
if(ishandle(temptext2)) delete(temptext2); end
temptext2=text(f2,10*log10(a2^2/2),'\bullet','Color','g','FontSize',24,'HorizontalAlignment','center');
setappdata(gcf,'temptext2',temptext2);

% --- Executes during object creation, after setting all properties.
function sliderF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


