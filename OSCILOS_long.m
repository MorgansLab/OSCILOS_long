function varargout = OSCILOS_long(varargin)
% -------------------------------------------------------------------------
%
% Copyright (c) <2014>, <Department of Aeronautics, Imperial College London>
% All rights reserved.
%
% -------------------------------------------------------------------------
% OSCILOS_LONG MATLAB code for OSCILOS_long.fig
%      OSCILOS_LONG, by itself, creates a new OSCILOS_LONG or raises the existing
%      singleton*.
%
%      H = OSCILOS_LONG returns the handle to a new OSCILOS_LONG or the handle to
%      the existing singleton*.
%
%      OSCILOS_LONG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCILOS_LONG.M with the given input arguments.
%
%      OSCILOS_LONG('Property','Value',...) creates a new OSCILOS_LONG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OSCILOS_long_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OSCILOS_long_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OSCILOS_long

% Last Modified by GUIDE v2.5 24-Oct-2014 09:19:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OSCILOS_long_OpeningFcn, ...
                   'gui_OutputFcn',  @OSCILOS_long_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
%
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before OSCILOS_long is made visible.
function OSCILOS_long_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OSCILOS_long (see VARARGIN)

% Choose default command line output for OSCILOS_long
handles.output = hObject;
guidata(hObject, handles);
%---------------------------------
% Initialization
Main_program_Initialization(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject, handles);
%---------------------------------
% Set waiting flag in appdata
setappdata(handles.figure,'waiting',1)
% UIWAIT makes changeme_main wait for user response (see UIRESUME)
uiwait(handles.figure);
 
% --- Outputs from this function are returned to the command line.
function varargout = OSCILOS_long_OutputFcn(hObject, eventdata, handles) 
varargout{1} = [];
% Now destroy yourself
delete(hObject);

% --------------------------------------------------------------------
function FILE_Callback(hObject, eventdata, handles)
% hObject    handle to FILE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function FILE_NS_Callback(hObject, eventdata, handles)
% hObject    handle to FILE_NS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

string={'Do you want to clear current data from the workspace'...
                    'and create a new calculation?'};
selection = questdlg(string,'Clear and create new session',...
  'Yes','No','Yes'); 
switch selection, 
  case 'Yes',
        clearvars -global
        Main_program_Initialization(hObject, eventdata, handles)
        handles=guidata(hObject);
  case 'No'
  return 
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function FILE_LS_Callback(hObject, eventdata, handles)
% hObject    handle to FILE_LS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
string = {  'Do you want to load data from existing Mat file?'...
            'The current data in the workspace may be deleted.'};
selection = questdlg(string,'Load session from existing Mat file',...
  'Yes','No','Yes'); 
switch selection 
  case 'Yes',
    clearvars -global
    handles = guidata(hObject);
    Main_program_Initialization(hObject, eventdata, handles)
    [filename, pathname] = uigetfile( ...
                                        {'*.mat','MATLAB Files (*.mat)';
                                           '*.*',  'All Files (*.*)'}, ...
                                           'Pick a file');
    if filename~=0
        load(filename);    
    end
    try
    assignin('base','CI',CI)
    catch
    end
    % ------------------------------
    try
        if CI.IsRun.GUI_INI_CD == 1;
            set(handles.INI_TP,         'enable','on')
        end
        if CI.IsRun.GUI_INI_TP == 1;
            set(handles.INI_FM,         'enable','on')
        end
        if CI.IsRun.GUI_INI_FM == 1 || CI.IsRun.GUI_INI_FMEXP == 1;
            set(handles.INI_BC,         'enable','on')
        end
        if CI.IsRun.GUI_INI_BC == 1;
            set(handles.FREQ,           'enable','on')
            set(handles.FREQ_EigCal,    'enable','on')
        end
    catch
    end
  case 'No'
  return 
end
guidata(hObject, handles); 

% --------------------------------------------------------------------
function FILE_SS_Callback(hObject, eventdata, handles)
% hObject    handle to FILE_SS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
selection = questdlg('Do you want to save current data?',...
  'Save current session to a Mat file',...
  'Yes','No','Yes'); 
switch selection 
    case 'Yes',
    [filename, pathname] = uiputfile(...
                                         {'Case1.mat'},...
                                         'Save as');
    if filename~=0
        try
            save(filename,'CI')  
        catch 
        end
    end
  case 'No'
  return 
end
%
% =========================================================================
%
function INI_Callback(hObject, eventdata, handles)
% hObject    handle to INI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function INI_CD_Callback(hObject, eventdata, handles)
% hObject    handle to INI_CD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Call GUI_INI_CD to change the configurations 
guidata(hObject,handles);
handles=guidata(hObject);
GUI_INI_CD('OSCILOS_long', handles.figure);

function INI_TP_Callback(hObject, eventdata, handles)
% hObject    handle to INI_TP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles=guidata(hObject);
GUI_INI_TP('OSCILOS_long', handles.figure);

function INI_FM_Callback(hObject, eventdata, handles)
% hObject    handle to INI_FM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles=guidata(hObject);
global CI
string={...
'The flame describing function (FDF) is configured in this pannel.'...
'One can use a simple nonlinear flame describing function model,'...
'which is assumed can be decoupled as a nonlinear model and a'...
'linear flame transfer function (FTF) model.'...
'One can also load experimental flame transfer functions  for'...
'different velocities, and fit the FTF data with state-space models.'};
choice = questdlg(string, ...
	'Flame describing function setting', ...
	'Decoupled FDF model','From experimental FDF','Decoupled FDF model');
% Handle response
switch choice
    case 'Decoupled FDF model'
        GUI_INI_FM('OSCILOS_long', handles.figure);
        CI.indexFM = 0;
    case 'From experimental FDF'
        CI.indexFM = 1;
        GUI_INI_FMEXP('OSCILOS_long', handles.figure);
end
assignin('base','CI',CI);



function INI_BC_Callback(hObject, eventdata, handles)
% hObject    handle to INI_BC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_INI_BC('OSCILOS_long', handles.figure);

function FREQ_Callback(hObject, eventdata, handles)
% hObject    handle to FREQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
function FREQ_EigCal_Callback(hObject, eventdata, handles)
% hObject    handle to FREQ_EigCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
indexOption = 0;
if isempty(CI.CD.HR_config) == 0
    HR_type = CI.CD.HR_config(:,3);
    if isempty(find(HR_type == 1)) == 0
        indexOption = 1; 
    end
end
CI.CD.system_type=indexOption;
switch indexOption
    case 0
        GUI_FREQ_EigCal('OSCILOS_long', handles.figure);
    case 1
        GUI_FREQ_EigCal_nonlinear_HR('OSCILOS_long', handles.figure);
end
assignin('base','CI',CI);



function TD_Callback(hObject, eventdata, handles)
% hObject    handle to TD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function TD_GreenFcn_Callback(hObject, eventdata, handles)
% hObject    handle to TD_GreenFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_TD_GreenFcn('OSCILOS_long', handles.figure);

% --------------------------------------------------------------------
function TD_SIM_Callback(hObject, eventdata, handles)
% hObject    handle to TD_SIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function EX_Callback(hObject, eventdata, handles)
% hObject    handle to EX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function EX_RT_Callback(hObject, eventdata, handles)
% hObject    handle to EX_RT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_RijkeTube('OSCILOS_long', handles.figure);

function HP_Callback(hObject, eventdata, handles)
% hObject    handle to HP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function HP_pdf_Callback(hObject, eventdata, handles)
% hObject    handle to HP_pdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% open('OSCILOS_Long_User_Guide.pdf')
% !OSCILOS_Long_User_Guide.pdf
if ispc
    open('OSCILOS_Long User Guide.pdf')
else
    msgbox('Please refer to ''OSCILOS_Long User Guide.pdf'' in the current folder!');
end


function HP_About_Callback(hObject, eventdata, handles)
% hObject    handle to HP_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
string={...
            'OSCILOS_long: Open-Source Combustion Instabilities Low-Order Simulator'; 
            '(For longitudinal modes)';...
            'Version: 1.3';...
            '';...
            'Developed by Dr. Jingxuan LI, Dong Yang and Dr. Aimee S.MORGANS';...
            'Published under the BSD licence';...
            '';...
            'Programmed with MATLAB 2013b';...
            'First released April 08, 2014';...
            '';...
            'http://www.oscilos.com/';...
            'Contact: jingxuan.li@imperial.ac.uk, a.morgans@imperial.ac.uk';...
            'Department of Aeronautics, Imperial College London, UK'
    };
helpdlg(string,'About')


% --- Executes on selection change in listbox_Info.
function listbox_Info_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_Info contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_Info


% --- Executes during object creation, after setting all properties.
function listbox_Info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% User-defined close request function 
% to display a question dialog box 
   selection = questdlg('Do you want to quit OSCILOS_long?',...
      'Quit?',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         uiresume(hObject);
         rmpath(genpath('./'))                    % remove directories from search path
      case 'No'
      return 
   end

%   
% ------------------------Main program initialization----------------------
%   
function Main_program_Initialization(varargin)
hObject = varargin{1};
handles = guidata(hObject);
clearvars -global
%------------------------------
% user define sets
% background colors 
handles.bgcolor{1} = [0.95, 0.95, 0.95];
handles.bgcolor{2} = [0, 0, 0];
handles.bgcolor{3} = [.75, .75, .75];
handles.bgcolor{4} = [0.90,0.90,1];
%
sW          = 800;                                      % screen width
sH          = 600;                                      % screen height
handles.sW  = sW;
handles.sH  = sH;
%
if ispc
    handles.FontSize(1) = 11;                 % set the default fontsize
    handles.FontSize(2) = 9;
else
    handles.FontSize(1) = 12;                 % set the default fontsize
    handles.FontSize(2) = 10;   
end
guidata(hObject, handles);
global CI                               
% CI means combustion instability
% CD means combustor dimensions information,
% TP means thermo-properties, 
% SD means save directory
% FM means flame model
% BC means boundary conditions
% CT means control
% TD means time domain calculation
%
CI.Ru       = 8.3145;
CI.W_air    = 28.96512;
CI.R_air    = CI.Ru./CI.W_air.*1000;
%
CI.SD.MainFigName = 'Figure';
idExist = exist(CI.SD.MainFigName,'file');
if idExist==0
    mkdir(CI.SD.MainFigName);
end
subFigName={'Figure_Initialization','Figure_Freq_Analysis','Figure_Time_Simulation'};
for i=1:length(subFigName)
    CI.SD.subFigName{i} = fullfile(CI.SD.MainFigName, subFigName{i});
    idExist = exist(CI.SD.subFigName{i},'file');
    if idExist==0
        mkdir(CI.SD.subFigName{i});
    end
end
CI.SD.name_program='subProgram';          % sub-program routine
addpath(genpath('./'))                    % add directories to search path
%
assignin('base','CI',CI);                   % save the current information to the workspace
%
% positions reconfiguration
set(0, 'units', 'points');
screenSize  = get(0, 'ScreenSize');                     % get the screen size
%
FigW=sW.*2/3;                                           % window width
FigH=sH.*2/3;                                             % window height
set(handles.figure,     'units',    'points',...
                        'position', [(screenSize(3)-FigW)./2 (screenSize(4)-FigH)./2 FigW FigH],...
                        'name',     'OSCILOS (for longitudinal modes)',...
                        'color',    handles.bgcolor{3});

% set Menu
% File
set(handles.FILE,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'File',...
                        'Position',             1,...
                        'visible',              'on')
%
set(handles.FILE_NS,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'New case',...
                        'Position',             1,...
                        'visible',              'on',...
                        'Accelerator',          'N' )
%
set(handles.FILE_LS,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Load...',...
                        'Position',             2,...
                        'visible',              'on',...
                        'Accelerator',          'L' )
set(handles.FILE_SS,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Save...',...
                        'Position',             3,...
                        'visible',              'on',...
                        'Accelerator',          'S' )
% Initialization
set(handles.INI,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Initialization',...
                        'Position',             2,...
                        'visible',              'on',...
                        'Accelerator',          '' )
set(handles.INI_CD,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Chamber dimensions',...
                        'Position',             1,...
                        'visible',              'on',...
                        'Accelerator',          'D' ) 
set(handles.INI_TP,...
                        'Enable',   'off',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Thermal properties',...
                        'Position',             2,...
                        'visible',              'on',...
                        'Accelerator',          'T' ) 
set(handles.INI_FM,...
                        'Enable',   'off',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Flame model',...
                        'Position',             3,...
                        'visible',              'on',...
                        'Accelerator',          'F' ) 
set(handles.INI_BC,...
                        'Enable',   'off',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Boundary conditions',...
                        'Position',             4,...
                        'visible',              'on',...
                        'Accelerator',          'B' )  
% Frequency domain analysis
set(handles.FREQ,...
                        'Enable',   'off',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Freq. domain analysis',...
                        'Position',             3,...
                        'visible',              'on',...
                        'Accelerator',          '' )
                    
set(handles.FREQ_EigCal,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Eigenmode calculation',...
                        'Position',             1,...
                        'visible',              'on',...
                        'Accelerator',          'E',...
                        'Separator',             'on')

% Time domain analysis

set(handles.TD,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Time domain simulation',...
                        'Position',             4,...
                        'visible',              'off',...
                        'Accelerator',          '' )
set(handles.TD_GreenFcn,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Examination of the Green''s function',...
                        'Position',             1,...
                        'visible',              'on',...
                        'Accelerator',          '' )
                    
set(handles.TD_SIM,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Simulation',...
                        'Position',             2,...
                        'visible',              'on',...
                        'Accelerator',          '' )
set(handles.HP,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'Help',...
                        'Position',             5,...
                        'visible',              'on',...
                        'Accelerator',          'H' )
set(handles.HP_About,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'About...',...
                        'Position',             1,...
                        'visible',              'on',...
                        'Accelerator',          '' )
set(handles.HP_pdf,...
                        'Enable',   'on',...
                        'ForegroundColor',      handles.bgcolor{2},...
                        'Label',                'User guide',...
                        'Position',             2,...
                        'visible',              'on',...
                        'Accelerator',          '' )
guidata(hObject, handles);
handles = guidata(hObject);
% -------------------------------------------------------------------------
% set(handles.uipanel_Logo,...
%                         'units', 'points',...
%                         'fontunits','points',...
%                         'position',[FigW*0.0/20 FigH*0/20 FigW*20/20 FigH*2.5/20],...
%                         'Title','',...
%                         'visible','on',...
%                         'highlightcolor',handles.bgcolor{3},...
%                         'borderwidth',1,...
%                         'fontsize',handles.FontSize(2),...
%                         'backgroundcolor',handles.bgcolor{3});  
% pannelsize=get(handles.uipanel_Logo,'position');
% pW=pannelsize(3);
% pH=pannelsize(4);  
% set(handles.axes1,      'units', 'points',...
%                         'position',[pW*0/10 pH*1/10 pW*2/10 pH*6/10],...
%                         'fontsize',handles.FontSize(1),...
%                         'color',handles.bgcolor{1},...
%                         'box','off');  
% set(handles.text_LOGO,...
%                         'units', 'points',...
%                         'Fontweight','bold',...
%                         'Fontunits','points',...
%                         'position',[pW*7.75/10 pH*2/10 pW*2/10 pH*4/10],...
%                         'fontsize',2.0*handles.FontSize(2),...
%                         'string','OSCILOS',...
%                         'backgroundcolor',handles.bgcolor{3},...
%                         'horizontalalignment','right');  
% Image1 = imread('ImperialLogo.png');
% hImage = imagesc(Image1);
% hAxis = get(hImage,'parent');
% set(hAxis,'visible','off')
set(handles.uipanel_Logo,...
                        'units', 'points',...
                        'fontunits','points',...
                        'position',[FigW*0.0/20 FigH*0/20 FigW*20/20 FigH*2.5/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_Logo,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
set(handles.axes1,      'units', 'points',...
                        'position',[pW*0.25/10 pH*1/10 pW*2/10 pH*6/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1},...
                        'box','off');  
[Image1, map, alpha] = imread('ImperialLogo1.png','BackgroundColor',handles.bgcolor{3});
hImage = imagesc(Image1);
hAxis = get(hImage,'parent');
set(hAxis,'visible','off')
%
set(handles.text_LOGO,...
                        'units', 'points',...
                        'Fontweight','bold',...
                        'Fontunits','points',...
                        'position',[pW*7.75/10 pH*2/10 pW*2/10 pH*4/10],...
                        'fontsize',2.0*handles.FontSize(2),...
                        'string','OSCILOS',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','right'); 

% -------------------------------------------------------------------------
set(handles.uipanel_Info,...
                        'units', 'points',...
                        'fontunits','points',...
                        'position',[FigW*0.0/20 FigH*2/20 FigW*20/20 FigH*18/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_Info,'position');
pW=pannelsize(3);
pH=pannelsize(4);                                
msg={   '<HTML><FONT color="red">Welcome to OSCILOS_long!';...
        'version 1.3';...
        ''};
set(handles.listbox_Info,...
                        'units', 'points',...
                        'fontunits','points',...
                        'position',[pW*1/20 pH*1/20 pW*18/20 pH*18/20],...
                        'fontsize',handles.FontSize(1),...
                        'string',msg,...
                        'backgroundcolor',handles.bgcolor{4},...
                        'value',1);    
% -------------------------------------------------------------------------
%  index indicates that if the sub GUI program has ever been run
% if index == 0, the sub GUI program has not been run
% if index == 1, has been run
CI.IsRun.GUI_INI_CD         = 0;
CI.IsRun.GUI_INI_TP         = 0;
CI.IsRun.GUI_INI_FM         = 0;
CI.IsRun.GUI_INI_FMEXP      = 0;
CI.IsRun.GUI_INI_BC         = 0;
CI.IsRun.GUI_INI_BC_Entropy = 0;
%
CI.IsRun.GUI_FREQ_EigCal    = 0;
CI.IsRun.GUI_FREQ_EigCal_nonlinear_HR = 0;
CI.IsRun.GUI_FREQ_EigCal_AD = 0;
%
assignin('base','CI',CI)
guidata(hObject, handles); 
% --------------------------------end--------------------------------------
