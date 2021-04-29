function varargout = GUI_INI_TP(varargin)
% GUI_INI_TP MATLAB code for GUI_INI_TP.fig
%      GUI_INI_TP, by itself, creates a new GUI_INI_TP or raises the existing
%      singleton*.
%
%      H = GUI_INI_TP returns the handle to a new GUI_INI_TP or the handle to
%      the existing singleton*.
%
%      GUI_INI_TP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INI_TP.M with the given input arguments.
%
%      GUI_INI_TP('Property','Value',...) creates a new GUI_INI_TP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_INI_TP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_INI_TP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_INI_TP

% Last Modified by GUIDE v2.5 08-Sep-2014 17:20:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_INI_TP_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_INI_TP_OutputFcn, ...
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
%--------------------------------------------------------------------------


% --- Executes just before GUI_INI_TP is made visible.
function GUI_INI_TP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_INI_TP (see VARARGIN)
%--------------------------------------------------------------------------
indexEdit = 0;
switch indexEdit 
    case 0
        %--------------------------------------------------------------------------
        dontOpen = false;
        mainGuiInput = find(strcmp(varargin, 'OSCILOS_long'));
        if (isempty(mainGuiInput)) ...
            || (length(varargin) <= mainGuiInput) ...
            || (~ishandle(varargin{mainGuiInput+1}))
            dontOpen = true;
        else % load from the main GUI
            % handles of main GUI
            handles.MainGUI = varargin{mainGuiInput+1};
            try
                handles.ExampleGUI = varargin{mainGuiInput+2};
            catch
            end
            % Obtain handles using GUIDATA with the caller's handle 
            mainHandles = guidata(handles.MainGUI);
            % background colors
            handles.bgcolor=mainHandles.bgcolor;
            % fontsize
            handles.FontSize=mainHandles.FontSize;
            %
            handles.sW = mainHandles.sW;
            handles.sH = mainHandles.sH;
            % Update handles structure
            guidata(hObject, handles);
            % Initialization
            GUI_INI_TP_Initialization(hObject, eventdata, handles)
            handles = guidata(hObject);
            guidata(hObject, handles);
        end
        % Update handles structure
        guidata(hObject, handles);
        if dontOpen
           disp('-----------------------------------------------------');
           disp('This is a subprogram. It cannot be run independently.') 
           disp('Please load the program "OSCILOS_long'' from the ')
           disp('parent directory!')
           disp('-----------------------------------------------------');
        else
           uiwait(hObject);
        end
    case 1
        global CI
        handles.bgcolor{1} = [0.95, 0.95, 0.95];
        handles.bgcolor{2} = [0, 0, 0];
        handles.bgcolor{3} = [.75, .75, .75];
        handles.bgcolor{4} = [0.90,0.90,1];
        %
        handles.sW  = 800;
        handles.sH  = 600;
        %
        if ispc
            handles.FontSize(1)=11;                 % set the default fontsize
            handles.FontSize(2)=9;
        else
            handles.FontSize(1)=12;                 % set the default fontsize
            handles.FontSize(2)=10;   
        end
        CI.Ru = 8.3145;
        assignin('base','CI',CI);                   % save the current information to the works
        guidata(hObject, handles);  
        GUI_INI_TP_Initialization(hObject, eventdata, handles)
        uiwait(hObject);
end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_INI_TP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];
delete(hObject);


% ----------------Mean flow properties pannel------------------------------
%
function edit_TP_p1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TP_p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_TP_p1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TP_p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_TP_T1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TP_T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_TP_T1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TP_T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_TP_M1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TP_M1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_TP_M1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TP_M1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ----------------Heat addition style--------------------------------------
%
% --- Executes on selection change in pop_HA_style.
function pop_HA_style_Callback(hObject, eventdata, handles)
% hObject    handle to pop_HA_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_HA_style contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_HA_style
handles=guidata(hObject);
pop_HA_style=get(hObject,'Value');
switch pop_HA_style
% {  'heater (Tb/Tu is given)';...
%    'combustion'}
    case 1
        set(handles.edit_TD_Tratio,             'Enable', 'on')
        set(handles.ObjEditEnable_FD,           'Enable', 'off')
    case 2
        set(handles.edit_TD_Tratio,             'Enable', 'off')
        set(handles.ObjEditEnable_FD,           'Enable', 'on')
 end
guidata(hObject, handles);
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function pop_HA_style_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_HA_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
% ----------------Heat addition from flame pannel--------------------------
%
function edit_FD_effi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FD_effi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_FD_effi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FD_effi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop_FD_fuel.
function pop_FD_fuel_Callback(hObject, eventdata, handles)
% hObject    handle to pop_FD_fuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_FD_fuel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_FD_fuel
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function pop_FD_fuel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_FD_fuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_FD_phi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FD_phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_FD_phi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FD_phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_FD_dilute_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FD_dilute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_FD_dilute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FD_dilute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_TD_Tratio_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TD_Tratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_TD_Tratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TD_Tratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ----------------Flame distribution pannel--------------------------------
%
% --- Executes on selection change in pop_FlameDistStyle.
function pop_FlameDistStyle_Callback(hObject, eventdata, handles)
% hObject    handle to pop_FlameDistStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_FlameDistStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_FlameDistStyle


% --- Executes during object creation, after setting all properties.
function pop_FlameDistStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_FlameDistStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% ----------------Flame distribution pannel--------------------------------
%
function edit_DT_flameW_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DT_flameW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
Fcn_disable_button(hObject)

% --- Executes during object creation, after setting all properties.
function edit_DT_flameW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DT_flameW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_DT_SN_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DT_SN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DT_SN as text
%        str2double(get(hObject,'String')) returns contents of edit_DT_SN as a double


% --- Executes during object creation, after setting all properties.
function edit_DT_SN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DT_SN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_DT_distS.
function pop_DT_distS_Callback(hObject, eventdata, handles)
% hObject    handle to pop_DT_distS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_DT_distS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_DT_distS


% --- Executes during object creation, after setting all properties.
function pop_DT_distS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_DT_distS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ----------------Plot pannel----------------------------------------------
%
% --- Executes on selection change in pop_plot.
function pop_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pop_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function pop_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_Plot.
function pb_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fcn_GUI_INI_TP_PLOT(hObject)

% --- Executes on button press in pb_saveFig.
function pb_saveFig_Callback(hObject, eventdata, handles)
% hObject    handle to pb_saveFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
Fig = figure;
set(Fig,        'units','points')
posFig = get(handles.figure,'position');
copyobj(handles.axes1, Fig);
hAxes = get(Fig,'children');
set(hAxes,      'units','points',...
                'position',[60 60 200 200])
posAxesOuter = [0 0 300 300];
set(Fig,        'units','points',...
                'position', [posFig(1)+0.5*posFig(3)-0.5*posAxesOuter(3),...
                            posFig(2)+0.5*posFig(4)-0.5*posAxesOuter(4),...
                            posAxesOuter(3:4)])           


% --- Executes on button press in pb_Cal.
function pb_Cal_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
guidata(hObject, handles);
% --------------------Msg box ---------------------------------------------
%
hMsg = msgbox('The calculation may take several seconds, please wait!','Calculation...');
%
hChildren       = get(hMsg,'children');
set(hChildren(2),       'units', 'points',...
                        'Fontunits','points',...
                        'fontsize',handles.FontSize(2),...
                        'string','OK',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'visible','off',...
                        'enable','off')
%
pause(1)                % paus 1 second
delete(hMsg)
%-----------------------------
Fcn_GUI_INI_TP_Calculation(hObject, eventdata, handles)
set(handles.pb_Cal,             'enable','on');
set(handles.pb_Plot,            'enable','on');
set(handles.pb_saveFig,         'enable','on');
set(handles.pb_OK,              'enable','on');
guidata(hObject, handles);




function Fcn_disable_button(varargin)
hObject = varargin{1};
handles = guidata(hObject);
set(handles.pb_Plot,            'enable','off');
set(handles.pb_saveFig,         'enable','off');
set(handles.pb_OK,              'enable','off');
guidata(hObject, handles);


% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
guidata(hObject, handles);
%
Fcn_GUI_INI_TP_Update(hObject, eventdata, handles)
%
handles = guidata(hObject);
guidata(hObject, handles);
global CI
CI.IsRun.GUI_INI_TP = 1;
assignin('base','CI',CI); 
uiresume(handles.figure);

% --- Executes on button press in pb_Cancel.
function pb_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure);

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(hObject);

% --- Update the data when clicking 'OK' or 'Apply'
function Fcn_GUI_INI_TP_Calculation(varargin)
hObject = varargin{1};
handles = guidata(hObject);
filename=fullfile('subProgram','GUI_Data');
addpath(filename) % add directory to search path, it includes some supportment documents
global CI
% 
% The inlet gas is considered as air, since the gamma and W of the mixture
% is nearly the same as those of air, with a error of 5%.
% The burned gases are processed by the program to calculate the mass
% fraction of the mixture
% It is considered that there exist one section before the flame and after
% the expansion of the section area. The width of this section tends to
% zero. Thus there are numSection+1 sections.
CI.TP.p_mean(1:2,1)     = str2num(get(handles.edit_TP_p1,'string'));
CI.TP.T_mean(1:2,1)     = str2num(get(handles.edit_TP_T1,'string'));
% This information is given in the main program
% CI.Ru    = 8.3145;
% CI.W_air = 28.96512;
% CI.R_air = CI.Ru./CI.W_air.*1000;
% calculate  Cp and gamma of air in unburned gases
% use the program:
% [ci,co,DeltaHr,Cp_o]=Fcn_calculation_c_q_air(Ti,To)
[CI.TP.c_mean(1:2,1),temp1,temp2,CI.TP.Cp(1:2,1)]   = Fcn_calculation_c_q_air(CI.TP.T_mean(1,1));
CI.TP.gamma(1:2,1)                                  = CI.TP.Cp(1,1)./(CI.TP.Cp(1,1) - CI.R_air);   % gamma
%
CI.TP.M1_u1_style                           = get(handles.pop_TP_M1_u1,'Value');       % Heat addition style
switch CI.TP.M1_u1_style
    case 1
        CI.TP.M_mean(1:2,1)     = str2num(get(handles.edit_TP_M1,'string'));
        CI.TP.u_mean(1:2,1)     = CI.TP.M_mean(1,1).*CI.TP.c_mean(1,1);       % mean velocity
    case 2
        CI.TP.u_mean(1:2,1)     = str2num(get(handles.edit_TP_M1,'string'));
        CI.TP.M_mean(1:2,1)     = CI.TP.u_mean(1,1)./CI.TP.c_mean(1,1);
end
CI.TP.rho_mean(1:2,1)           = CI.TP.p_mean(1,1)./(CI.R_air.*CI.TP.T_mean(1,1));
CI.TP.numSection                = length(CI.CD.x_sample)-1;
for ss = 1:CI.TP.numSection-1 
    CI.TP.Theta(ss)  = (CI.CD.r_sample(ss+1)./CI.CD.r_sample(ss)).^2;      % Surface area ratio S2/S1
end
%
% --------------------------------
% Begin adding by Dong Yang
Liner_Flag = 1; % Initialize the flag of the Liner considered by the loop
HR_Flag = 1;    % Initialize the flag of the HR considered by the loop
% End adding by Dong Yang
% --------------------------------
for ss = 1:CI.TP.numSection-1 
    [   CI.TP.p_mean(1:2,ss+1),...
        CI.TP.rho_mean(1:2,ss+1),...
        CI.TP.u_mean(1:2,ss+1) ]... 
      = Fcn_calculation_TP_mean_WO_HeatAddition(CI.TP.p_mean(1,ss),...
                                                CI.TP.rho_mean(1,ss),...
                                                CI.TP.u_mean(1,ss),...
                                                CI.TP.Theta(ss),...
                                                CI.TP.gamma(1,ss));
    % ----------
    CI.TP.gamma(1:2,ss+1)   = CI.TP.gamma(1,ss);
    CI.TP.Cp(1:2,ss+1)      = CI.TP.Cp(1,ss);
    CI.TP.T_mean(1:2,ss+1)  = CI.TP.gamma(1,ss+1)/(CI.TP.gamma(1,ss+1)-1)...
                             *CI.TP.p_mean(1,ss+1)./(CI.TP.Cp(1,ss+1).*CI.TP.rho_mean(1,ss+1));
    CI.TP.c_mean(1:2,ss+1)  = ((CI.TP.gamma(1,ss+1) - 1).*CI.TP.Cp(1,ss+1).*CI.TP.T_mean(1,ss+1)).^0.5;
    CI.TP.M_mean(1:2,ss+1)  = CI.TP.u_mean(1,ss+1)./CI.TP.c_mean(1,ss+1);
    % ----------
    switch CI.CD.index(ss+1)
        case 0
        case 1
            [T_ratio, CI.TP.c_mean(1,ss+1), CI.TP.DeltaHr, CI.TP.gamma(1,ss+1), CI.TP.Cp(1,ss+1)] =...
                Fcn_GUI_INI_TP_calculation_products_after_HA(hObject,CI.TP.T_mean(2,ss+1),CI.TP.p_mean(2,ss+1));
            CI.TP.T_mean(1,ss+1) = T_ratio.*CI.TP.T_mean(2,ss+1);
            CI.TP.T_ratio = T_ratio;
            Rg2 = CI.TP.Cp(1,ss+1)./(CI.TP.gamma(1,ss+1)./(CI.TP.gamma(1,ss+1)-1));
            [   CI.TP.p_mean(1,ss+1),...               
                CI.TP.rho_mean(1,ss+1),...
                CI.TP.u_mean(1,ss+1)] = ...
            Fcn_calculation_TP_mean_W_HeatAddition( CI.TP.p_mean(2,ss+1),...
                                                    CI.TP.rho_mean(2,ss+1),...
                                                    CI.TP.u_mean(2,ss+1),...
                                                    Rg2,...
                                                    CI.TP.T_mean(1,ss+1));
            CI.TP.M_mean(1,ss+1)  = CI.TP.u_mean(1,ss+1)./CI.TP.c_mean(1,ss+1);
            CI.TP.Q = CI.TP.DeltaHr.*CI.TP.rho_mean(2,ss+1).*CI.TP.u_mean(2,ss+1).*CI.CD.r_sample(ss+1).^2.*pi;
        % ----------------------------------
        % Begin adding by Dong Yang
        case 2            
            % Typically, it can be assumed that mean flow will not be affect by the HR, anyway, 
            % the following procedure is an alternate way to calculate mean parameters across the crosssection where the resonator is installed.      
            
            section_Num=ss;
            [   CI.TP.T_mean(1,ss+1),...               
                CI.TP.rho_mean(1,ss+1),...
                CI.TP.u_mean(1,ss+1),...
                CI.TP.Cp(1,ss+1),...
                CI.TP.gamma(1,ss+1)] = ...
            Fcn_calculation_TP_mean_across_HR( HR_Flag,...
                                               section_Num,...
                                               CI.TP.T_mean(2,ss+1),...
                                               CI.TP.rho_mean(2,ss+1),...
                                               CI.TP.u_mean(2,ss+1));
                CI.TP.p_mean(1:2,ss+1)  = CI.TP.T_mean(1,ss+1).*CI.TP.rho_mean(1,ss+1)*(CI.TP.gamma(1,ss+1)-1)./CI.TP.gamma(1,ss+1)*CI.TP.Cp(1,ss+1);
                CI.TP.c_mean(1:2,ss+1)  = ((CI.TP.gamma(1,ss+1) - 1).*CI.TP.Cp(1,ss+1).*CI.TP.T_mean(1,ss+1)).^0.5;
                CI.TP.M_mean(1:2,ss+1)  = CI.TP.u_mean(1,ss+1)./CI.TP.c_mean(1,ss+1); 
            HR_Flag = HR_Flag+1;
        case 30
            % Nothing happens because mean flow properties are constant
            % across the input side cross-section of the lined duct
        case 31
            % It is assumed only mean flow velocity will increase a bit in
            % the lined duct region.
            [ CI.TP.u_mean(1,ss+1)] = Fcn_calculation_TP_mean_across_Liner(Liner_Flag,ss+1);
            CI.TP.M_mean(1,ss+1)=CI.TP.u_mean(1,ss+1)/CI.TP.c_mean(1,ss+1);
            Liner_Flag = Liner_Flag+1;
        % End adding by Dong Yang
        % ----------------------------------
    end
end
%
guidata(hObject, handles);
assignin('base','CI',CI)
% Fcn_GUI_INI_TP_PLOT(hObject)        % plot the figures
guidata(hObject, handles);
%


% -------------------------------------------------------------------------
function [T_ratio, c_mean2, DeltaHr, gamma2, Cp2] =...
         Fcn_GUI_INI_TP_calculation_products_after_HA(hObject,T_mean1,p_mean1)
handles         = guidata(hObject);
global CI
CI.TP.HA_style  = get(handles.pop_HA_style,'Value');       % Heat addition style
switch CI.TP.HA_style
    case 1
        % temperature determined
        T_ratio = str2num(get(handles.edit_TD_Tratio,'string'));
        T_mean2 = T_mean1*T_ratio;
        [temp1,c_mean2,DeltaHr,Cp2] = Fcn_calculation_c_q_air(T_mean1,T_mean2);
        gamma2  = Cp2./(Cp2-CI.R_air);     
    case 2
        % fuel determined
        CI.TP.indexFuel = get(handles.pop_FD_fuel,'value');                     % index of fuel
        CI.TP.eff       = str2num(get(handles.edit_FD_effi,     'string'));     % combustion efficiency
        CI.TP.Phi       = str2num(get(handles.edit_FD_phi,      'string'));     % equivalence ratio
        CI.TP.dil       = str2num(get(handles.edit_FD_dilute,   'string'));     % diluted ratio
    [   T_mean2,...
        CI.TP.chi,...
        DeltaHr,...
        c_mean2,...
        Cp2,...
        CI.TP.WProd ] = ...
            Fcn_calculation_combustion_products(CI.TP.indexFuel,...
                                                CI.TP.Phi,...
                                                T_mean1,...
                                                p_mean1,...
                                                CI.TP.eff,...
                                                CI.TP.dil);
        T_ratio     = T_mean2./T_mean1;         % Temperature jump ratio
        CI.TP.RProd = CI.Ru./(CI.TP.WProd).*1000;        % gas constant per mass for the combustion product
        gamma2      = Cp2./(Cp2-CI.TP.RProd);
        set(handles.edit_TD_Tratio,'string',num2str(T_ratio));
    otherwise
        % Code for when there is no match.
end
guidata(hObject, handles);
assignin('base','CI',CI)
% -------------------------------------------------------------------------


% -------------------update----------------------------------------------
%
function Fcn_GUI_INI_TP_Update(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
%
% try
main = handles.MainGUI;
% Obtain handles using GUIDATA with the caller's handle 
if(ishandle(main))
    mainHandles = guidata(main);
    if get(handles.pop_HA_style,'value') ==1 && str2double(get(handles.edit_TD_Tratio,'string')) ==1
        msgbox('You have chosen the isothermal run and do not need to set the flame model!');
        changeMain = mainHandles.INI_BC;
        % ------------------------   
        CI.FM.FTF.style     = 2;
        CI.FM.NL.style      = 1;
        CI.FM.FTF.af        = 1;
        CI.FM.FTF.tauf      = 3e-3;
        CI.FM.FTF.fc        = 75;
        CI.FM.FTF.omegac    = 2*pi*CI.FM.FTF.fc;
        CI.FM.FTF.num       = CI.FM.FTF.omegac;
        CI.FM.FTF.den       = [1 CI.FM.FTF.omegac];
        % -------------------------
        CI.indexFM          = 0;
        assignin('base','CI',CI);
        % ------------------------ 
    else
        changeMain = mainHandles.INI_FM;
    end
    set(changeMain, 'Enable', 'on');
    String_Listbox=get(mainHandles.listbox_Info,'string');
    ind=find(ismember(String_Listbox,'<HTML><FONT color="blue">Information 2:'));
    nLength=size(String_Listbox);
    if isempty(ind)
        indStart=nLength(1);
    else
        indStart=ind-1;
        for i=nLength(1):-1:indStart+1 
            String_Listbox(i)=[];
        end
    end
    NameFuel={  'CH4_Methane','C2H4_Ethylene','C2H6_Ethane','C3H8_Propane',...
            'C4H8_Butene','C4H10_n_butane',...
            'C4H10_isobutane','C12H23_Jet_A(g)'};
    String_Listbox{indStart+1}='<HTML><FONT color="blue">Information 2:';
    String_Listbox{indStart+2}=['<HTML><FONT color="blue">Mean flow and thermal properties:'];
    switch CI.CD.isNoFlame
    case 0
        if CI.TP.HA_style==1
            String_Listbox{indStart+3}=['The inlet gas is pure air'];
            String_Listbox{indStart+4}=['Air is directly heated at the flame holder position by a heater'];
        else
            String_Listbox{indStart+3}=['The inlet gas is air+' NameFuel{get(handles.pop_FD_fuel,'value')} ' mixture'];
            String_Listbox{indStart+4}=['The fresh mixture reacts to combustion products at the flame holer'];
        end
        String_Listbox{indStart+5}=['The mean heat release rate is:'];
        String_Listbox{indStart+6}=[num2str(CI.TP.Q./1000) ' kW'];
    case 1
        String_Listbox{indStart+3}=['There is no heat addition!'];
    end
        String_Listbox{indStart+7}=['The mean temperature in different sections are:'];
        String_Listbox{indStart+8}=[num2str(CI.TP.T_mean(1,:)) ' K'];
        String_Listbox{indStart+9}=['The mean pressure in different sections are:'];
        String_Listbox{indStart+10}=[num2str(CI.TP.p_mean(1,:)) ' Pa'];
        String_Listbox{indStart+11}=['The mean velocity in different sections are:'];
        String_Listbox{indStart+12}=[num2str(CI.TP.u_mean(1,:)) ' m/s'];
        String_Listbox{indStart+13}=['The mean speed of sound in different sections are:'];
        String_Listbox{indStart+14}=[num2str(CI.TP.c_mean(1,:)) ' m/s'];
    set(mainHandles.listbox_Info,'string',String_Listbox,'value',1);
end
% end
guidata(hObject, handles);
assignin('base','CI',CI)

function GUI_INI_TP_Initialization(varargin)
hObject = varargin{1};
handles = guidata(hObject);
%--------------------------------------
set(0, 'units', 'points');
screenSize  = get(0, 'ScreenSize');                 % get the screen size
sW          = handles.sW;                           % screen width
sH          = handles.sH ;                          % screen height
FigW=sW.*4/5;                                        % window width
FigH=sH.*3/5;                                        % window height
set(handles.figure,     'units', 'points',...
                        'position',[(screenSize(3)-FigW)./2 (screenSize(4)-FigH)./2 FigW FigH],...
                        'name','Mean flow and thermal properties configuration',...
                        'color',handles.bgcolor{3});
NameFuel={  'CH4_Methane','C2H4_Ethylene','C2H6_Ethane','C3H8_Propane',...
            'C4H8_Butene','C4H10_n_butane',...
            'C4H10_isobutane','C12H23_Jet_A(g)'};                    
%----------------------------------------
% pannel axes
set(handles.uipanel_axes,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*10.5/20 FigW*19/20 FigH*9.25/20],...
                        'Title','Plots:',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_axes,'position');
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.axes1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1/10 pH*2/10 pW*6/10 pH*6.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1});
                    
set(handles.text_plot,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8/10 pH*8/10 pW*1.75/10 pH*1.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Plot:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');
                   
set(handles.pop_plot,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8/10 pH*6.5/10 pW*1.75/10 pH*1.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'Mean velocity:';'Mean temperature'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left');
set(handles.pb_Plot,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8/10 pH*4.5/10 pW*1.75/10 pH*1.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Plot figure',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'visible','on',...
                        'enable','off');  
set(handles.pb_saveFig,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8/10 pH*2.0/10 pW*1.75/10 pH*1.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Save figure',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'visible','on',...
                        'enable','off');  
%----------------------------------------                    
% pannel initial thermal properties
set(handles.uipanel_ITP,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*8/20 FigW*19/20 FigH*2.25/20],...
                        'Title','Inlet mean flow properties',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_ITP,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_TP_p1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*1.5/10 pW*1.5/10 pH*4.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','p1_mean [Pa]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                    
set(handles.edit_TP_p1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1.5/10 pH*2/10 pW*1.25/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',101325,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                    
set(handles.text_TP_T1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.5/10 pH*1.5/10 pW*1.5/10 pH*4.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','T1_mean [K]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                    
set(handles.edit_TP_T1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*4.75/10 pH*2/10 pW*1.25/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',293.15,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');
set(handles.pop_TP_M1_u1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6.5/10 pH*2.25/10 pW*1.5/10 pH*4.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'M1_mean [-]:';'Mean velocity [m/s]'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1);                    
set(handles.edit_TP_M1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.25/10 pH*2./10 pW*1.25/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0.001,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');
%----------------------------------------                    
% pannel heat addition style 
set(handles.uipanel_HA_style,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*5.5/20 FigW*19/20 FigH*2.25/20],...
                        'Title','Heat addition style',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_HA_style,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_HA_style,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*1.5/10 pW*1.5/10 pH*4.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Heat from:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.pop_HA_style,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1.5/10 pH*2.0/10 pW*2/10 pH*4.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{  'Heating grid (Tb/Tu is given)';...
                                    'Fuel combustion'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1);  
set(handles.text_TD_Tratio,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*4.0/10 pH*1.5/10 pW*4/10 pH*4.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Temperature ratio across the flame Tb/Tu [-]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');
set(handles.edit_TD_Tratio,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.25/10 pH*2.0/10 pW*2.5/20 pH*4.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',1,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'enable','on');
%---------------------------------------- 
% pannel heat addition configuration
set(handles.uipanel_Heat_Config,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*2/20 FigW*19/20 FigH*4/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_Heat_Config,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
% row 1  
set(handles.text_FD_fuel,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*5/10 pW*1.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Fuel:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.pop_FD_fuel,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1.5/10 pH*5.25/10 pW*2.0/10 pH*2.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',NameFuel,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','off');

set(handles.text_FD_CbEff,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*5/10 pW*3/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Combustion efficiency:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_FD_effi,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.25/10 pH*5/10 pW*1.25/10 pH*2.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',1,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'enable','off');                    
% row 2  
set(handles.text_FD_phi,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*1.5/10 pW*3.0/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Equivalence ratio [-]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');
set(handles.edit_FD_phi,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.25/10 pH*1.5/10 pW*1.25/10 pH*2.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',1,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'enable','off');
set(handles.text_FD_dilute,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*1.5/10 pW*3.0/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Dilution ratio [-]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');
set(handles.edit_FD_dilute,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.25/10 pH*1.5/10 pW*1.25/10 pH*2.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'enable','off');                                 
%---------------------------------------- 
% pannel heat addition style 
set(handles.uipanel_FlameDistStyle,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*8.0/20 FigW*19/20 FigH*1.75/20],...
                        'Title','Heat addition style',...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});
%----------------------------------------                    
% pannel flame distribution
set(handles.uipanel_flameDist,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*5.5/20 FigH*2.25/20 FigW*14/20 FigH*3.25/20],...
                        'Title','Initial thermal properties',...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_flameDist,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_DT_flameW,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*5/10 pW*2.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Flame length [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_DT_flameW,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3/10 pH*5.5/10 pW*1.5/10 pH*2.2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'enable','off');
set(handles.text_DT_distS,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5/10 pH*5/10 pW*2/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Distributed form:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                                                                              
set(handles.pop_DT_distS,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*7.25/10 pH*4.5/10 pW*2.5/10 pH*3/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'Uniform distribution:';'Triangular distribution';'Gaussian distribution'; 'Conical flame'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','off');
set(handles.text_DT_SN,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*1/10 pW*2.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Sample number [-]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_DT_SN,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3/10 pH*1.5/10 pW*1.5/10 pH*2.2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',10,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'enable','off');
%----------------------------------------
% pannel Apply OK Cancel                   
set(handles.uipanel_OK,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*0/20 FigW*19/20 FigH*1.75/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_OK,'position');                    
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.pb_Cal,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.7/10 pH*2/10 pW*2.4/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Calculate...',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'enable','on');
set(handles.pb_OK,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.8/10 pH*2/10 pW*2.4/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','OK',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'enable','off');
set(handles.pb_Cancel,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6.9/10 pH*2/10 pW*2.4/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Cancel',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'enable','on'); 
%
%---------------------------------------
handles.ObjEditEnable_TP = findobj('-regexp','Tag','_TP_');
handles.ObjEditEnable_FD = findobj('-regexp','Tag','_FD_');
% default enable settings
set(handles.ObjEditEnable_TP,    'Enable','on');
set(handles.ObjEditEnable_FD,    'Enable','off');
guidata(hObject, handles);
%--------------------------------------------------------------------------
name_program='subProgram';          % sub-program routine
addpath(name_program)               % add directory to search path
global CI
indexExist_CI_TP=any(strcmp('TP',fieldnames(CI)));
if indexExist_CI_TP==1;
    set(handles.pb_Cal,             'enable','on');
    set(handles.pb_Plot,            'enable','on');
    set(handles.pb_saveFig,         'enable','on');
    set(handles.pb_OK,              'enable','on');
    set(handles.edit_TP_p1,'string', num2str(CI.TP.p_mean(1,1)));
    set(handles.edit_TP_T1,'string', num2str(CI.TP.T_mean(1,1)));
    set(handles.edit_TP_M1,'string', num2str(CI.TP.M_mean(1,1)));
    set(handles.pop_HA_style,'value',CI.TP.HA_style)
        pop_HA_style=CI.TP.HA_style;
        switch pop_HA_style
        % {  'heater (Tb/Tu is given)';...
        %    'combustion'}
            case 1
                set(handles.edit_TD_Tratio,             'Enable', 'on')
                set(handles.ObjEditEnable_FD,           'Enable', 'off')
            case 2
                set(handles.edit_TD_Tratio,             'Enable', 'off')
                set(handles.ObjEditEnable_FD,           'Enable', 'on')
         end
    try
        set(handles.edit_TD_Tratio, 'string', num2str(CI.TP.T_ratio));
        set(handles.pop_FD_fuel,    'value', CI.TP.indexFuel);
        set(handles.edit_FD_phi,    'string', num2str(CI.TP.Phi));
        set(handles.edit_FD_effi,   'string', num2str(CI.TP.eff));
        set(handles.edit_FD_dilute, 'string', num2str(CI.TP.dil));
    catch
    end
end
CI.TP.HA_style  = get(handles.pop_HA_style,'Value');       % Heat addition style
assignin('base','CI',CI); 
Fcn_GUI_INI_TP_Switch_with_without_flame(hObject)
guidata(hObject, handles);
%
%-------------------------------------------------------------------------
%
function Fcn_GUI_INI_TP_PLOT(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
hAxes1=handles.axes1;
pop_plot = get(handles.pop_plot,'Value');
%------------------------------------
cla(hAxes1)
axes(hAxes1)
hold on
set(hAxes1,'YColor','k','Box','on','ygrid','on','xgrid','on');
set(hAxes1,'FontName','Helvetica','FontSize',handles.FontSize(1),'LineWidth',1)
xlabel(hAxes1,'$x $ [m]','Color','k','Interpreter','LaTex','FontSize',handles.FontSize(1));
set(hAxes1,'xlim',[CI.CD.x_sample(1), CI.CD.x_sample(end)],...
    'xtick',CI.CD.x_sample(1:end),...
    'YAxisLocation','left','Color','w');
%
N = length(CI.CD.index);
x_plots(1,1:N-1) = CI.CD.x_sample(1:N-1);
x_plots(2,1:N-1) = CI.CD.x_sample(2:N);
%
switch pop_plot
    case 1  
        for ss = 1:N-1
            y_plots(1:2,ss) = CI.TP.u_mean(1,ss);
        end
        ylabel(hAxes1,'$\bar{u}$ [m/s]','Color','k','Interpreter','LaTex','FontSize',handles.FontSize(1));
    case 2
        for ss = 1:N-1
            y_plots(1:2,ss) = CI.TP.T_mean(1,ss);
        end
        ylabel(hAxes1,'$\bar{T}$ [K]','Color','k','Interpreter','LaTex','FontSize',handles.FontSize(1));
end
%
for ss = 1:N-1
    ColorUDF{ss} = 'b';         % color of the line
end
indexFlame = find(CI.CD.index == 1);
if isempty(indexFlame) == 0
    for ss = indexFlame:N-1
        ColorUDF{ss} = 'r';
    end
end
indexLiner = find(CI.CD.index == 30);
if isempty(indexLiner) == 0
   switch pop_plot
        case 1  
            y_plots(2,indexLiner) = CI.TP.u_mean(1,indexLiner+1);
        case 2
            y_plots(2,indexLiner) = CI.TP.T_mean(1,indexLiner+1);
   end
end
%
for ss = 1:N-1
    plot(hAxes1,[x_plots(1,ss),x_plots(2,ss)],[y_plots(1,ss),y_plots(2,ss)],...
        'color',ColorUDF{ss},'linewidth',2,'linestyle','-');
end
if isempty(indexFlame) == 0
    plot(hAxes1,[x_plots(1,indexFlame),x_plots(1,indexFlame)],[y_plots(1,indexFlame-1),y_plots(1,indexFlame)],...
        'color','g','linewidth',2,'linestyle','--');
end
yvalue_max  = max(max(y_plots));
yvalue_min  = min(min(y_plots));  
ymax        = yvalue_max+round((yvalue_max-yvalue_min).*10)./50+eps;
ymin        = yvalue_min-round((yvalue_max-yvalue_min).*10)./50-eps;
if ymax<=ymin
    ymax = ymax+0.1*mean(mean(y_plots));
    ymin = ymin-0.1*mean(mean(y_plots));
end
set(hAxes1,'ylim',[ymin ymax])
hold off    
%
assignin('base','CI',CI); 
% 
% -------------------------------------------------------------------------



% --- Executes on selection change in pop_TP_M1_u1.
function pop_TP_M1_u1_Callback(hObject, eventdata, handles)
% hObject    handle to pop_TP_M1_u1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_TP_M1_u1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_TP_M1_u1
pop_type_MU = get(hObject,'value');
global CI
switch pop_type_MU 
    case 1
        set(handles.edit_TP_M1,'string','0.001')
        try
        set(handles.edit_TP_M1,'string',num2str(CI.TP.M_mean(1,1)))
        catch
        end
    case 2
        set(handles.edit_TP_M1,'string','1')
        try
        set(handles.edit_TP_M1,'string',num2str(CI.TP.u_mean(1,1)))
        catch
        end
end

% --- Executes during object creation, after setting all properties.
function pop_TP_M1_u1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_TP_M1_u1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pop_TP_M1_u1.
function pop_TP_M1_u1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pop_TP_M1_u1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
