function varargout = GUI_FREQ_EigCal(varargin)
% GUI_FREQ_EIGCAL MATLAB code for GUI_FREQ_EigCal.fig
%      GUI_FREQ_EIGCAL, by itself, creates a new GUI_FREQ_EIGCAL or raises the existing
%      singleton*.
%
%      H = GUI_FREQ_EIGCAL returns the handle to a new GUI_FREQ_EIGCAL or the handle to
%      the existing singleton*.
%
%      GUI_FREQ_EIGCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FREQ_EIGCAL.M with the given input arguments.
%
%      GUI_FREQ_EIGCAL('Property','Value',...) creates a new GUI_FREQ_EIGCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_FREQ_EigCal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_FREQ_EigCal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_FREQ_EigCal

% Last Modified by GUIDE v2.5 22-Oct-2014 17:07:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_FREQ_EigCal_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_FREQ_EigCal_OutputFcn, ...
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


% --- Executes just before GUI_FREQ_EigCal is made visible.
function GUI_FREQ_EigCal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_FREQ_EigCal (see VARARGIN)
% --------------------------------------------------------------------------
handles.indexEdit = 1;
switch handles.indexEdit 
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
            GUI_FREQ_EigCal_Initialization(hObject, eventdata, handles)
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
%         CI.IsRun.GUI_FREQ_EigCal = 0;
        assignin('base','CI',CI);                   % save the current information to the works
        guidata(hObject, handles);  
        GUI_FREQ_EigCal_Initialization(hObject, eventdata, handles)
        uiwait(hObject);
end
%
% -------------------------------------------------------------------------
%
function GUI_FREQ_EigCal_Initialization(varargin)
hObject = varargin{1};
handles = guidata(hObject);
handles.ObjEditEnable_AOC = findobj('-regexp','Tag','_AOC_');
guidata(hObject, handles);  
Fcn_PreProcessing
global CI
set(0, 'units', 'points');
screenSize  = get(0, 'ScreenSize');                 % get the screen size
sW          = handles.sW;                           % screen width
sH          = handles.sH;                          % screen height
FigW=sW.*1;                                        % window width
FigH=sH.*3/4;                                        % window height
set(handles.figure,     'units', 'points',...
                        'position',[(screenSize(3)-FigW)./2 (screenSize(4)-FigH)./2 FigW FigH],...
                        'name','Eigenvalue calculation',...
                        'color',handles.bgcolor{3});
%----------------------------------------
% pannel axes
set(handles.uipanel_Axes,   'units', 'points',...
                        'fontUnits','points',...
                        'position',[FigW*9.5/20 FigH*2.25/20 FigW*10/20 FigH*17.25/20],...
                        'Title','Plots',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_Axes,'position');
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.axes1,  'units', 'points',...
                        'position',[pW*2/10 pH*5.0/10 pW*6.0/10 pH*3.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1},...
                        'box','on');  
set(handles.axes2, 'units', 'points',...
                        'position',[pW*2/10 pH*1.5/10 pW*6.0/10 pH*3.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1},...
                        'box','on');  
set(handles.pop_numMode,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*5.5/10 pH*8.5/10 pW*4/10 pH*1.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'Mode number:1';'Mode number:2'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'visible','off');  
set(handles.pop_PlotType,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*8.5/10 pW*4/10 pH*1.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'Map of eigenvalues';'Modeshape'; 'Evolution of eigenvalue with velocity ratio'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','off'); 

guidata(hObject, handles);
%----------------------------------------
% pannel initialize velocity range information 
set(handles.uipanel_INI,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[FigW*0.5/20 FigH*12.5/20 FigW*8.5/20 FigH*7/20],...
                        'Title','Set velocity perturbation ratio range ',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize = get(handles.uipanel_INI,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
set(handles.text_min,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*7.0/10 pW*6/10 pH*1.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Minimum value (u''/u_bar): [-]',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_min,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*7/10 pH*7/10 pW*2.5/10 pH*1.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'Enable','on');
set(handles.text_max,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*5.0/10 pW*6/10 pH*1.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Maximum value (u''/u_bar): [-]',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_max,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*7/10 pH*5/10 pW*2.5/10 pH*1.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',1,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'Enable','on');                    
set(handles.text_SampNum,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*3.0/10 pW*6/10 pH*1.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Number of velocity ratio samples: [-]',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_SampNum,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*7/10 pH*3/10 pW*2.5/10 pH*1.25/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',11,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'Enable','on');                   
set(handles.pb_CalEig,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*5.5/10 pH*0.5/10 pW*4/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Calculate eigenvalues',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_SetScanDomain,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*0.5/10 pW*4/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Set scan range',...
                        'backgroundcolor',handles.bgcolor{3});
%----------------------------------------
% pannel 2
set(handles.uipanel_CAL,...
                        'units', 'points',...
                        'position',[FigW*0.5/20 FigH*2.25/20 FigW*8.5/20 FigH*9.75/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize = get(handles.uipanel_CAL,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
cnames = {'Eigen-frequency [Hz]','Growth rate [rad/s]'};
%
set(handles.text_Table,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*9.25/10 pW*9.0/10 pH*0.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Eigenvalues for selected velocity ratio',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
                    
set(handles.uitable,    'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*4/10 pW*9/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'columnName',cnames,...
                        'data',[],...
                        'backgroundcolor',handles.bgcolor{1},...
                        'RearrangeableColumns','on'); 
set(handles.text_uRatio,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*2.25/10 pW*6/10 pH*0.9/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Selected velocity ratio: [-]',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_uRatio,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*7/10 pH*2.5/10 pW*2.5/10 pH*0.9/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'Enable','off');                    
set(handles.slider_uRatio,...
                        'units', 'points',...
                        'fontUnits','points',...
                        'position',[pW*0.5/10 pH*0.5/10 pW*9/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'Enable','off',...
                        'min',1,...
                        'max',str2double(get(handles.edit_SampNum,'string')),...
                        'value',1);
                    
%---------------------------
% pannel AOC                   
set(handles.uipanel_AOC,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*0/20 FigW*19/20 FigH*1.75/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_AOC,'position');                    
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.pb_AOC_Plot,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.4/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Plot figure',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_AOC_SaveFig,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*2.8/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Save figure',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'enable','off');
set(handles.pb_AOC_OK,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.2/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','OK',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_Cancel,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*7.6/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Cancel',...
                        'backgroundcolor',handles.bgcolor{3});
% --------------------------------
%

% default enable settings
set(handles.ObjEditEnable_AOC,    'Enable','on');
%
guidata(hObject, handles);
GUI_FREQ_EigCal_Initialization_check_ever_run(hObject)
handles = guidata(hObject);
%
assignin('base','CI',CI)

%----------------------------------------
guidata(hObject, handles);
%

function GUI_FREQ_EigCal_Initialization_check_ever_run(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
if  CI.indexFM == 0 && CI.FM.NL.style == 1
    set(handles.edit_min,       'string',num2str(0),...
                                'enable','off');
    set(handles.edit_max,       'string',num2str(1),...
                                'enable','off');
    set(handles.edit_SampNum,   'string',num2str(2),...
                                'enable','off');
end
if  CI.indexFM == 1      % From experimental FDF
    set(handles.edit_min,       'string',num2str(min(CI.FMEXP.uRatio)),...
                                'enable','off');
    set(handles.edit_max,       'string',num2str(max(CI.FMEXP.uRatio)),...
                                'enable','off');
    set(handles.edit_SampNum,   'string',num2str(length(CI.FMEXP.uRatio)),...
                                'enable','off');
end
switch CI.IsRun.GUI_FREQ_EigCal
    case 0
        set(handles.ObjEditEnable_AOC,    'Enable','off');
    case 1 
        set(handles.ObjEditEnable_AOC,    'Enable','on');
        set(handles.slider_uRatio,...
                        'Enable','on',...
                        'min',1,...
                        'max',CI.EIG.FDF.uRatioNum,...
                        'value',1,...
                        'SliderStep',[1/(CI.EIG.FDF.uRatioNum-1), 1/(CI.EIG.FDF.uRatioNum-1)]);
        set(handles.edit_uRatio,'string',num2str(CI.EIG.FDF.uRatioSp(1)));
        set(handles.pop_numMode,    'enable','on');  
        set(handles.pop_PlotType,   'enable','on'); 
        set(handles.pb_AOC_Plot,         'enable','on');
        set(handles.edit_min,       'string',num2str(CI.EIG.FDF.uRatioSp(1)));
        set(handles.edit_max,       'string',num2str(CI.EIG.FDF.uRatioSp(end)));
        set(handles.edit_SampNum,   'string',num2str(CI.EIG.FDF.uRatioNum));
        eigenvalue = CI.EIG.Scan.EigValCol{1};
        for k = 1:length(eigenvalue)
           StringMode{k} = ['Mode number: ' num2str(k)]; 
        end
        set(handles.pop_numMode,    'string',StringMode)
        %
        data_num(:,1)=abs(imag(eigenvalue)./2./pi);
        data_num(:,2)=real(eigenvalue);
        data_cell=num2cell(data_num);
        set(handles.uitable,'data',data_cell);         % Update the table
        guidata(hObject, handles);
        GUI_FREQ_EigCal_PLOT(hObject)
end
%
switch CI.IsRun.GUI_FREQ_EigCal_AD 
    case 0
        CI.EIG.Scan.FreqMin = 1;
        CI.EIG.Scan.FreqMax = 1000;
        CI.EIG.Scan.FreqNum = 10;
        CI.EIG.Scan.GRMin   = -200;
        CI.EIG.Scan.GRMax   = 200;
        CI.EIG.Scan.GRNum   = 10;
    case 1
end
%
assignin('base','CI',CI);
%

% -------------------------------------------------------------------------
%
% --- Outputs from this function are returned to the command line.
function varargout = GUI_FREQ_EigCal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];
delete(hObject);

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(hObject);

% ---------------------------Pannel initialization-------------------------
%
function edit_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uRatio_min      = str2double(get(handles.edit_min,'string'));
uRatio_max      = str2double(get(handles.edit_max,'string'));
if isnan(uRatio_min)
    set(handles.edit_min, 'String', 0);
    errordlg('Input must be a number','Error');
end
if uRatio_min<=0
    set(handles.edit_min, 'String', 0);
end
if uRatio_max <= uRatio_min
    set(handles.edit_min, 'String', 0);
    set(handles.edit_max, 'String', 1);
    errordlg('Minimum value input must be smaller than Maximum value input','Error');
end

% --- Executes during object creation, after setting all properties.
function edit_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uRatio_min      = str2double(get(handles.edit_min,'string'));
uRatio_max      = str2double(get(handles.edit_max,'string'));
if isnan(uRatio_max)
    set(handles.edit_max, 'String', 1);
    errordlg('Input must be a number','Error');
end
if uRatio_max<=0
    set(handles.edit_max, 'String', 1);
end
if uRatio_max <= uRatio_min
    set(handles.edit_min, 'String', 0);
    set(handles.edit_max, 'String', 1);
    errordlg('Minimum value input must be smaller than Maximum value input','Error');
end

% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_SampNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SampNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uRatio_SampNum  = str2double(get(handles.edit_SampNum,'string'));
if isnan(uRatio_SampNum )
    set(handles.edit_SampNum, 'String', 11);
    errordlg('Input must be a number','Error');
end
if uRatio_SampNum <=0
    set(handles.edit_SampNum, 'String', 11);
    errordlg('Input must be a positive integer','Error');
end
if rem(uRatio_SampNum ,1)~=0
    set(handles.edit_SampNum, 'String', num2str(ceil(datEdit)));
end

% --- Executes during object creation, after setting all properties.
function edit_SampNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SampNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_SetScanDomain.
function pb_SetScanDomain_Callback(varargin)
hObject     = varargin{1};
handles     = guidata(hObject);
GUI_FREQ_EigCal_AD('GUI_FREQ_EigCal', handles.figure);

% --- Executes on button press in pb_CalEig.
function pb_CalEig_Callback(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
global FDF
%
%
Fcn_pb_CalEig_Value_initialization(hObject)
handles     = guidata(hObject);
guidata(hObject, handles);
%
%
% ---------------calculate the eigenvalues---------------
%
hWaitBar = waitbar(0,'The calculation may take several minutes, please wait...');
for ss =1:CI.EIG.FDF.uRatioNum
    FDF.uRatio  = CI.EIG.FDF.uRatioSp(ss);
    FDF.num     = CI.EIG.FDF.num{ss};
    FDF.den     = CI.EIG.FDF.den{ss};
    FDF.tauf    = CI.EIG.FDF.tauf(ss);
    assignin('base','FDF',FDF);
    CI.EIG.Scan.EigValCol{ss}   = Fcn_calculation_eigenvalues;
    CI.EIG.Cont.ValCol{ss}      = Fcn_calculation_contour;
    waitbar(ss/CI.EIG.FDF.uRatioNum);
    drawnow
end
close(hWaitBar)
assignin('base','CI',CI);
% ---------------update the table---------------
data_num(:,1)   = abs(imag(CI.EIG.Scan.EigValCol{1})./2./pi);
data_num(:,2)   = real(CI.EIG.Scan.EigValCol{1});
data_cell       = num2cell(data_num);
set(handles.uitable,'data',data_cell);         % Update the table
% ---------------update the table---------------
%
% ---------------update the slider---------------
if CI.EIG.FDF.uRatioNum == 1
    set(handles.slider_uRatio,'visible','off')
else
set(handles.slider_uRatio,...
                        'Enable','on',...
                        'min',1,...
                        'max',CI.EIG.FDF.uRatioNum,...
                        'value',1,...
                        'SliderStep',[1/(CI.EIG.FDF.uRatioNum-1), 1/(CI.EIG.FDF.uRatioNum-1)]);
end
set(handles.edit_uRatio,'string',num2str(CI.EIG.FDF.uRatioSp(1)));
indexShow=1;
CI.EIG.uR.indexShow=indexShow;
assignin('base','CI',CI);

% ---------------update the slider---------------
set(handles.pop_numMode,        'enable','on');  
set(handles.pop_PlotType,       'enable','on');
set(handles.pb_AOC_Plot,        'enable','on');
set(handles.pb_AOC_SaveFig,     'enable','on');
set(handles.pb_AOC_OK,          'enable','on');
% --
eigenvalue = CI.EIG.Scan.EigValCol{1};
for k = 1:length(eigenvalue)
   StringMode{k} = ['Mode number: ' num2str(k)]; 
end
set(handles.pop_numMode,    'string',StringMode)
guidata(hObject, handles);
%
% -------------------------------------------------------------------------
%
function Fcn_pb_CalEig_Value_initialization(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
%
% -------------------- s coordinates grids --------------------------------
% For scan
CI.EIG.Scan.GRSp        = linspace( CI.EIG.Scan.GRMin,...
                                    CI.EIG.Scan.GRMax,...
                                    CI.EIG.Scan.GRNum);
CI.EIG.Scan.FreqSp      = linspace( CI.EIG.Scan.FreqMin,...
                                    CI.EIG.Scan.FreqMax,...
                                    CI.EIG.Scan.FreqNum);
% For Contour
CI.EIG.Cont.GRSp        = linspace( CI.EIG.Scan.GRMin,...
                                    CI.EIG.Scan.GRMax,...
                                 10*CI.EIG.Scan.GRNum);
CI.EIG.Cont.FreqSp      = linspace( CI.EIG.Scan.FreqMin,...
                                    CI.EIG.Scan.FreqMax,...
                                 10*CI.EIG.Scan.FreqNum);
%
% -------------------- Flame describing function information --------------
%
%  
if  CI.indexFM == 0      % From flame model
    uRatioMin           = str2double(get(handles.edit_min,'string'));
    uRatioMax           = str2double(get(handles.edit_max,'string'));
    uRatioNum           = str2double(get(handles.edit_SampNum,'string'));
    CI.EIG.FDF.uRatioSp = linspace(uRatioMin,uRatioMax,uRatioNum);
    switch CI.FM.NL.style
    case 1
        for ss = 1:uRatioNum
            CI.EIG.FDF.num{ss}   = CI.FM.FTF.num;
            CI.EIG.FDF.den{ss}   = CI.FM.FTF.den;
            CI.EIG.FDF.tauf(ss)  = CI.FM.FTF.tauf;     
        end  
    case 2
        for ss = 1:uRatioNum
            CI.EIG.FDF.num{ss}   = CI.FM.FTF.num;
            CI.EIG.FDF.den{ss}   = CI.FM.FTF.den;
            CI.EIG.FDF.tauf(ss)  = CI.FM.FTF.tauf;     
            % something must be done to include the nonlinear in the Fcn_DetEqn.m
        end  
    case 3      
        CI.EIG.FDF.Lf       = interp1(  CI.FM.NL.Model3.uRatio,...
                                        CI.FM.NL.Model3.Lf,...
                                        CI.EIG.FDF.uRatioSp,'linear','extrap');         % Nonlinear ratio
        CI.EIG.FDF.taufNSp  = CI.FM.NL.Model3.taufN.*(1-CI.EIG.FDF.Lf);                % Nonlinear time delay
        for ss = 1:uRatioNum
            CI.EIG.FDF.num{ss}   = CI.EIG.FDF.Lf(ss).*CI.FM.FTF.num;
            CI.EIG.FDF.den{ss}   = CI.FM.FTF.den;
            CI.EIG.FDF.tauf(ss)  = CI.FM.FTF.tauf + CI.EIG.FDF.taufNSp(ss);     % Time delay of the FDF model
        end    
    end
elseif CI.indexFM == 1  % From experimental FDF
    CI.EIG.FDF.uRatioSp = CI.FMEXP.uRatio;
    uRatioNum = length(CI.EIG.FDF.uRatioSp);
    for ss = 1:uRatioNum
        FTF = CI.FMEXP.FTF{ss};
        CI.EIG.FDF.num{ss}  = FTF.num;
        CI.EIG.FDF.den{ss}  = FTF.den;
        CI.EIG.FDF.tauf(ss) =-FTF.tau_correction;  % Be careful: we always use a = a0 exp(-a*tau)
    end
end
CI.EIG.FDF.uRatioNum = uRatioNum;
assignin('base','CI',CI);
%
% -------------------------------------------------------------------------

%
% --- Executes on slider movement.
function slider_uRatio_Callback(hObject, eventdata, handles)
% hObject    handle to slider_uRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
ValueSlider     = get(hObject,'Value');
indexShow       = round(ValueSlider);
set(handles.edit_uRatio,'string',num2str(CI.EIG.FDF.uRatioSp(indexShow)));
%
data_num(:,1)   = abs(imag(CI.EIG.Scan.EigValCol{indexShow})./2./pi);
data_num(:,2)   = real(CI.EIG.Scan.EigValCol{indexShow});
data_cell       = num2cell(data_num);
set(handles.uitable,'data',data_cell);         % Update the table

% Update the plotType choices
pop_PlotType = get(handles.pop_PlotType, 'Value');
switch pop_PlotType
    case 1
        set(handles.pop_numMode,        'visible','off',...
                                        'enable','on');
    case 2
        set(handles.pop_numMode,        'visible','on',...
                                        'enable','on',...
                                        'Value',1); 
        % Renew the number of modes with this u-ratio
        eigenvalue          = CI.EIG.Scan.EigValCol{indexShow};
        for k = 1:1:length(eigenvalue)
        StringMode{k} = ['Mode number: ' num2str(k)]; 
        end
        set(handles.pop_numMode,    'string',StringMode);
        
    case 3
        set(handles.pop_numMode,        'visible','on',...
                                        'enable','on',...
                                        'Value',1);
        % The number of modes is always the same as that of the first group
        eigenvalue          = CI.EIG.Scan.EigValCol{1};
        for k = 1:1:length(eigenvalue)
        StringMode{k} = ['Mode number: ' num2str(k)]; 
        end
        set(handles.pop_numMode,     'string',StringMode);
end

guidata(hObject, handles);

CI.EIG.uR.indexShow=indexShow;
assignin('base','CI',CI);

% --- Executes during object creation, after setting all properties.
function slider_uRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_uRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_uRatio_Callback(hObject, eventdata, handles)
% hObject    handle to edit_uRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_uRatio as text
%        str2double(get(hObject,'String')) returns contents of edit_uRatio as a double
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
set(handles.pb_PlotC_M,     'enable','off');
set(handles.pb_AOC_Plot,  'enable','off');
set(handles.edit_indexMode1,'enable','off');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_uRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_uRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ---------------------------Pannel axes-----------------------------------
%
% --- Executes on selection change in pop_numMode.
function pop_numMode_Callback(hObject, eventdata, handles)
% hObject    handle to pop_numMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_numMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_numMode

% --- Executes during object creation, after setting all properties.
function pop_numMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_numMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_PlotType.
function pop_PlotType_Callback(hObject, eventdata, handles)
% hObject    handle to pop_PlotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_PlotType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_PlotType
global CI
pop_PlotType = get(hObject,'Value');
set(handles.pb_AOC_SaveFig,     'enable','OFF');
% set(handles.pb_AOC_SaveFig,'enable','off');
switch pop_PlotType
    case 1
        set(handles.pop_numMode,        'visible','off',...
                                        'enable','on');
    case 2
        set(handles.pop_numMode,        'visible','on',...
                                        'enable','on',...
                                        'Value',1);
        % Check and change the number of modes based on the indexShow
        ValueSlider         = get(handles.slider_uRatio,'Value');
        indexShow           = round(ValueSlider);  
        eigenvalue          = CI.EIG.Scan.EigValCol{indexShow};
        for k = 1:1:length(eigenvalue)
        StringMode{k} = ['Mode number: ' num2str(k)]; 
        end
        set(handles.pop_numMode,     'string',StringMode);
          
    case 3
        set(handles.pop_numMode,        'visible','on',...
                                        'enable','on',...
                                        'Value',1);
        % The number of modes is always the same as that of the first group
        eigenvalue          = CI.EIG.Scan.EigValCol{1};
        for k = 1:1:length(eigenvalue)
        StringMode{k} = ['Mode number: ' num2str(k)]; 
        end
        set(handles.pop_numMode,     'string',StringMode);  
    otherwise
        % Not possible to happen
end
        

% --- Executes during object creation, after setting all properties.
function pop_PlotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_PlotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ---------------------------Pannel AOC-----------------------------------
%
% --- Executes on button press in pb_AOC_Plot.
function pb_AOC_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to pb_AOC_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% indexMode=str2num(get(handles.edit_indexMode1,'string'));
% Fcn_plot_eigenmode(indexMode)
GUI_FREQ_EigCal_PLOT(hObject)
set(handles.pb_AOC_SaveFig,     'enable','on');


% --- Executes on button press in pb_AOC_SaveFig.
function pb_AOC_SaveFig_Callback(varargin)
%
hObject = varargin{1};
handles = guidata(hObject);
pop_PLot            = get(handles.pop_PlotType,'Value');
Fig = figure;
set(Fig,        'units','points')
posFig = get(handles.figure,'position');
copyobj(handles.axes1, Fig);
copyobj(handles.axes2, Fig);

hAxes = get(Fig,'children');
set(hAxes(2),       'units','points',...
                    'position',[80 60 200 150],...
                    'ActivePositionProperty','position')
set(hAxes(1),       'units','points',...
                    'position',[80 210 200 150],...
                    'ActivePositionProperty','position')
pos1 = get(hAxes(1),'position');
pos2 = get(hAxes(2),'position');
switch pop_PLot
    case 1
%         try
            posAxesOuter = [0 0 450 400];
            set(hAxes(2),       'position',[80 80 300 300])
            set(hAxes(1),       'position',[80 80 300 300])
            pos1CT=get(hAxes(1),'position');
            pos2CT=get(hAxes(2),'position');
            colormap(hot);
            hcb=colorbar;
            ylimhcb  = handles.hColorbar.ylimit;       
            hcb_ylim = get(hcb,'ylim');
            hcb_yticklabel = round(linspace(ylimhcb(1),ylimhcb(2),6).*10)./10;
            hcb_ytick = linspace(hcb_ylim(1),hcb_ylim(2),6);
            set(hcb,'ytick',hcb_ytick,'yticklabel',hcb_yticklabel);
            set(hcb,'Fontsize',handles.FontSize(2),'box','on','Unit','points')
            set(hcb,'position',[380,80,10,300])
            set(hAxes(1),       'position',pos1CT)
            set(hAxes(2),       'position',pos2CT) 
%         catch
%         end
    otherwise
        posAxesOuter = [0 0 300 400];
end
set(Fig,        'units','points',...
                'position', [posFig(1)+0.5*posFig(3)-0.5*posAxesOuter(3),...
                            posFig(2)+0.5*posFig(4)-0.5*posAxesOuter(4),...
                            posAxesOuter(3:4)])  

% --- Executes on button press in pb_AOC_OK.
function pb_AOC_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_AOC_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
CI.IsRun.GUI_FREQ_EigCal = 1;
assignin('base','CI',CI);
uiresume(handles.figure);

% --- Executes on button press in pb_Cancel.
function pb_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure);

%-------------------------------------------------------------------------
function GUI_FREQ_EigCal_PLOT(varargin)
hObject             = varargin{1};
handles             = guidata(hObject);
global CI
global FDF
hAxes1              = handles.axes1;
hAxes2              = handles.axes2;
fontSize1           = handles.FontSize(1);
fontSize2           = handles.FontSize(2);
CI.EIG.pop_numMode  = get(handles.pop_numMode,  'Value');
CI.EIG.pop_PlotType = get(handles.pop_PlotType, 'Value');
ValueSlider         = get(handles.slider_uRatio,'Value');
indexShow           = round(ValueSlider);   
Eigenvalue          = CI.EIG.Scan.EigValCol{indexShow};
ValueContour        = CI.EIG.Cont.ValCol{indexShow};
pannelsize          = get(handles.uipanel_Axes,'position');
pW = pannelsize(3);
pH = pannelsize(4); 
%
guidata(hObject, handles)
%
switch CI.EIG.pop_PlotType
% {'Map of eigenvalues';
%  'Modeshape';
%  'Evolution of eigenvalue with velocity ratio'}
    case 1      % Map of eigenvalues;
    set(handles.pop_numMode,'enable','off'); 
    set(hAxes1,'position',[pW*1.5/10 pH*1.5/10 pW*7/10 pH*7/10]);  
    position_hAxes1=get(hAxes1,'position');
    try
        cbh = findobj( 0, 'tag', 'Colorbar' );
        delete(cbh)
    catch
    end
    cla(hAxes1,'reset')
    axes(hAxes1)
    hold on
    %
    contourf(hAxes1,CI.EIG.Cont.GRSp./100,CI.EIG.Cont.FreqSp,20*log10(abs(ValueContour')))
    drawnow
    ylimitUD = [CI.EIG.Scan.FreqMin CI.EIG.Scan.FreqMax];
    xlimitUD = [CI.EIG.Scan.GRMin   CI.EIG.Scan.GRMax]./100;
    hold off
    %
    set(hAxes1,'YColor','k','Box','on');
    set(hAxes1,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
    xlabel(hAxes1,  '$ Re(s)/100: \textrm{Growth rate}~~/100~~$ [rad s$^{-1}$] ',...
        'Color','k','Interpreter','LaTex','FontSize',fontSize1);
    ylabel(hAxes1,'$ Im(s)/2\pi: \textrm{Frequency}~~$ [Hz]','Color','k',...
        'Interpreter','LaTex','FontSize',fontSize1);
    set(hAxes1,'ylim',ylimitUD,'YAxisLocation','left','Color','w');
    set(hAxes1,'xlim',xlimitUD);
    grid on
    colorbar 
    colormap(hot);
    hcb=colorbar;
    set(hcb,'Fontsize',fontSize2,'box','on','Unit','points')
    set(hcb,'position',[position_hAxes1(1)+position_hAxes1(3),...
                        position_hAxes1(2),...
                        position_hAxes1(3)./20,...
                        position_hAxes1(4).*1]);
    set(hAxes1,'position',position_hAxes1)
        hcb_ylim=get(hcb,'ylim');
        handles.hColorbar.ylimit=[  min(min(20*log10(abs(ValueContour')))),...
                                    max(max(20*log10(abs(ValueContour'))))];
        guidata(hObject, handles)
    %------------------------------------
    cla(hAxes2,'reset')
    axes(hAxes2)
    set(hAxes2,'position',get(hAxes1,'position'));
    hold on
    plot(hAxes2,real(Eigenvalue)./100,imag(Eigenvalue)./2./pi,'p',...
        'markersize',8,'color','k','markerfacecolor',[1,1,1])
    drawnow
    hold off
    set(hAxes2,     'ylim', get(hAxes1,'ylim'),...
                    'yTick',get(hAxes1,'ytick'),...
                    'yticklabel',[],...
                    'YAxisLocation','left','Color','none');
    set(hAxes2,     'xlim', get(hAxes1,'xlim'),...
                    'xTick',get(hAxes1,'xtick'),...
                    'xticklabel',[],...
                    'xcolor','b','ycolor','b','gridlinestyle','-.');
    set(hAxes2,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',0.5)
    grid on
    %------------------------
    xt_pos=min((get(hAxes2,'xlim')))+1.15*(max((get(hAxes1,'xlim'))) - min((get(hAxes1,'xlim'))));
    yt_pos=mean(get(hAxes2,'ylim'));
    hTitle = title(hAxes2, 'Eigenvalues are located at minima');
    set(hTitle, 'interpreter','latex', 'fontunits','points','fontsize',fontSize1)
    guidata(hObject, handles);
    %--------------------
    case 2 %'Modeshape'
    set(handles.pop_numMode,'enable','on');
    set(hAxes1,'position',[pW*2.0/10 pH*1.5/10 pW*7/10 pH*3.5/10]); 
    set(hAxes2,'position',[pW*2.0/10 pH*5.0/10 pW*7/10 pH*3.5/10]); 
    try
        cbh = findobj( 0, 'tag', 'Colorbar' );
        delete(cbh)
    catch
    end
    s_star = Eigenvalue(CI.EIG.pop_numMode);             % eigenvalue
    FDF.num     = CI.EIG.FDF.num{indexShow};
    FDF.den     = CI.EIG.FDF.den{indexShow};
    FDF.tauf    = CI.EIG.FDF.tauf(indexShow);
    assignin('base','FDF',FDF);
    [x_resample,p,u] = Fcn_calculation_eigenmode(s_star);
    cla(hAxes1,'reset')
    axes(hAxes1)
    drawnow
    hold on
    for k=1:length(CI.CD.x_sample)-1
        plot(hAxes1,x_resample(k,:),abs(p(k,:)),'-','color','k','Linewidth',2)
    end
    ymax1=max(max(abs(p)));
    ymin1=floor(min(min(abs(p))));
    ylimitUD=[ymin1 ymax1+0.25*(ymax1-ymin1)];
    ytickUD=linspace(ylimitUD(1),ylimitUD(2),6);
    for ss=1:length(ytickUD)
        yticklabelUD{ss}=num2str(ytickUD(ss));
    end
    yticklabelUD{end}='';
    xmax1=max(max(x_resample));
    xmin1=min(min(x_resample));
    xlimitUD=[xmin1 xmax1];
    xtickUD=linspace(xlimitUD(1),xlimitUD(2),6);

    set(hAxes1,'YColor','k','Box','on');
    set(hAxes1,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
    xlabel(hAxes1,'$x $ [m]','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    ylabel(hAxes1,'$|~\hat{p}~|~(Pa)$ ','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    set(hAxes1,     'ylim', ylimitUD,...
                    'yTick',ytickUD,...
                    'yticklabel',yticklabelUD,...
                    'YAxisLocation','left');
    set(hAxes1,'xlim',xlimitUD,'xtick',xtickUD);
    ylimit=get(hAxes1,'ylim');
    for k=1:length(CI.CD.x_sample)
       plot(hAxes1,[CI.CD.x_sample(k),CI.CD.x_sample(k)],ylimit,'--','linewidth',1,'color','k') 
    end
    grid on
    hold off
    %-----------------------
    cla(hAxes2,'reset')
    axes(hAxes2)
    drawnow
    hold on
    for k=1:length(CI.CD.x_sample)-1
        plot(hAxes2,x_resample(k,:),abs(u(k,:)),'-','color','k','Linewidth',2)
    end
    set(hAxes2,'YColor','k','Box','on');
    set(hAxes2,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
    set(hAxes2,     'xlim', get(hAxes1,'xlim'),...
                    'xTick',get(hAxes1,'xtick'),...
                    'xticklabel',[]);
    xlabel(hAxes2,'','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    ylabel(hAxes2,'$|~\hat{u}~|~(m/s)$ ','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    ylimit=get(hAxes2,'ylim');
    for k=1:length(CI.CD.x_sample)
       plot(hAxes2,[CI.CD.x_sample(k),CI.CD.x_sample(k)],ylimit,'--','linewidth',1,'color','k') 
    end
    grid on
    hold off
    guidata(hObject, handles);
    %--------------------------------
    case 3 %'Evolution of eigenvalue with velocity ratio'
        % Consider modes moving out of or into the searching region
        uRatioNum     =CI.EIG.FDF.uRatioNum;
        Modes_Num     =length(CI.EIG.Scan.EigValCol{1});
        EigFreq       =abs(imag(CI.EIG.Scan.EigValCol{1}))/2/pi;
        frequency_gap =min(abs(diff(EigFreq)));
        if uRatioNum==1
            set(hObject, 'String', 0);
            errordlg('There is not any evolution result','Error');
        else
            for M_Num=1:1:Modes_Num 
                EigFreq_mode(M_Num,1)    = abs(imag(CI.EIG.Scan.EigValCol{1}(M_Num)))/2/pi;
                EigGR_mode(M_Num,1)      = real(CI.EIG.Scan.EigValCol{1}(M_Num));
                k=2;
                Ratio_num_step=1;
                while k<=uRatioNum
                      mod_fre_diff  =abs(EigFreq(M_Num)-abs(imag(CI.EIG.Scan.EigValCol{k}))/2/pi);
                      [min_fre_diff,min_mod_num]= min(mod_fre_diff);
                      if min_fre_diff<frequency_gap/2
                         EigFreq_mode(M_Num,k)     = abs(imag(CI.EIG.Scan.EigValCol{k}(min_mod_num)))/2/pi;
                         EigGR_mode(M_Num,k)       = real(CI.EIG.Scan.EigValCol{k}(min_mod_num));
                         Ratio_num_step            = Ratio_num_step+1;
                         k                         = k+1;
                      else
                          k=k+1;
                      end
                end
                uRatio_num(M_Num)                       =Ratio_num_step;
                uRatio_mode(M_Num,1:1:uRatio_num(M_Num))=CI.EIG.FDF.uRatioSp(1:1:uRatio_num(M_Num));
                   
            end   
        end
    % Get the pop_numMode and plot its evolution 
    set(handles.pop_numMode,'enable','on');
    set(hAxes1,'position',[pW*2.0/10 pH*1.5/10 pW*7/10 pH*3.5/10]); 
    set(hAxes2,'position',[pW*2.0/10 pH*5.0/10 pW*7/10 pH*3.5/10]); 
    try
        cbh = findobj( 0, 'tag', 'Colorbar' );
        delete(cbh)
    catch
    end    
    % Calculate the eigen values for a specific mode
    x       = uRatio_mode(CI.EIG.pop_numMode,1:uRatio_num(CI.EIG.pop_numMode));
    EigFreq = EigFreq_mode(CI.EIG.pop_numMode,1:uRatio_num(CI.EIG.pop_numMode));
    EigGR   = EigGR_mode(CI.EIG.pop_numMode,1:uRatio_num(CI.EIG.pop_numMode));
    % End calculating eigen values for a specific mode
    cla(hAxes1,'reset')
    axes(hAxes1)
    hold on
    plot(hAxes1,x,EigFreq,'-o','color','k','Linewidth',1)
    hold off
    ymax1=ceil(max(max(EigFreq)));
    ymin1=floor(min(min(EigFreq)));
    ylimitUD=[ymin1-0.25*(ymax1-ymin1)-0.5 ymax1+0.25*(ymax1-ymin1)+0.5];
    ytickUD=linspace(ylimitUD(1),ylimitUD(2),7);
    for ss=1:length(ytickUD)
        yticklabelUD{ss}=num2str(ytickUD(ss));
    end
    yticklabelUD{end}='';
    xmax1=max(max(x));
    xmin1=min(min(x));
    xlimitUD=[xmin1-0.1*xmin1 xmax1+0.1*xmin1];
    xtickUD=linspace(xlimitUD(1),xlimitUD(2),6);

    set(hAxes1,'YColor','k','Box','on');
    set(hAxes1,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
    xlabel(hAxes1,'$\hat{u}_1/\bar{u}_1 $ [-]','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    ylabel(hAxes1,'Frequency [Hz] ','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    set(hAxes1,     'ylim', ylimitUD,...
                    'yTick',ytickUD,...
                    'yticklabel',yticklabelUD,...
                    'YAxisLocation','left');
    set(hAxes1,'xlim',xlimitUD,'xtick',xtickUD);
    grid on
    hold off
    %-----------------------
    cla(hAxes2,'reset')
    axes(hAxes2)
    drawnow
    hold on
    plot(hAxes2,x,EigGR,'-o','color','k','Linewidth',1)
    hold off
    set(hAxes2,'YColor','k','Box','on');
    set(hAxes2,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
    set(hAxes2,     'xlim', get(hAxes1,'xlim'),...
                    'xTick',get(hAxes1,'xtick'),...
                    'xticklabel',[]);
    xlabel(hAxes2,'','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    ylabel(hAxes2,'Growth rate [rad/s] ','Color','k','Interpreter','LaTex','FontSize',fontSize1);
    grid on
    guidata(hObject, handles);
end
assignin('base','CI',CI);                   % save the current information to the workspace

% ----------------------------Calculate eigenvalue-------------------------
%
function E = Fcn_calculation_eigenvalues
% This function is used to calculate the eigenvalue 
global CI
%---------------------------------
% set the scan domain
FreqMin     = CI.EIG.Scan.FreqMin;   
FreqMax     = CI.EIG.Scan.FreqMax;
FreqNum     = CI.EIG.Scan.FreqNum;
GRMin       = CI.EIG.Scan.GRMin;   
GRMax       = CI.EIG.Scan.GRMax;
GRNum       = CI.EIG.Scan.GRNum;
FreqSp      = linspace(FreqMin, FreqMax,    FreqNum);       % sample number of scan frequency
GRSp        = linspace(GRMin,   GRMax,      GRNum);         % sample number of growth rate
%---------------------------------
options = optimset('Display','off');        % the calculation results by fsolve will not be shown in the workspace
eigen_num=1;
for ss = 1:length(GRSp)
    GR = GRSp(ss);
    for kk = 1:length(FreqSp)
        omega = 2*pi*FreqSp(kk);
        s0 = GR+1i*omega;                                                           % initial value
        [x,fval,exitflag] = fsolve(@Fcn_DetEqn,s0,options);                         % solve equation        
        if exitflag==1;
        EIG.eigenvalue(eigen_num)=x;
        EIG.eigenvalue_prec(eigen_num) = floor(EIG.eigenvalue(eigen_num)./10).*10;      % this is used to set the precision
        eigen_num=eigen_num+1;
        end
    end
end
[b,m,n] = unique(EIG.eigenvalue_prec);                      % unique function is used to get rid of the same value
EIG.eigenvalue_unique = EIG.eigenvalue(m);                  % this is the eigenvalue
EIG.eigenvalue_unique_prec = EIG.eigenvalue_prec(m);
%---------------------------------
% this is used to get rid of the zero frequency value
s_null = [];
cal = 0;
for ss = 1:length(EIG.eigenvalue_unique)
    if(abs(imag(EIG.eigenvalue_unique(ss)))<1)
        cal = cal+1;
        s_null(cal) = ss;
    end
end
EIG.eigenvalue_unique(s_null) = [];
%---------------------------------
% the previous processing is still not enough to get rid of the same
% value,such as 999.9 and 1000.1 corresponding to the function `floor'
% such as 995.1 and 994.9 corresponding to the function `round'
cal = 0;
EIG.eigenvalue_unique = sort(EIG.eigenvalue_unique);
EIG.eigenvalue_unique_diff = diff(EIG.eigenvalue_unique);
EIG.index_NULL = [];
for kk = 1:length(EIG.eigenvalue_unique_diff)
    if(abs(EIG.eigenvalue_unique_diff(kk))<10)
        cal = cal+1;
        EIG.index_NULL(cal) = kk;
    end
end
EIG.eigenvalue_unique(EIG.index_NULL) = []; % this is the eigenvalue we want

EIG.growthrate_limit    = [GRMin    GRMax];
EIG.Omega_limit         = [FreqMin  FreqMax].*2.*pi;
%-------------------------------------
s_null=[];
cal=0;
for ss=1:length(EIG.eigenvalue_unique)
    if(real(EIG.eigenvalue_unique(ss))<EIG.growthrate_limit(1)||real(EIG.eigenvalue_unique(ss))>EIG.growthrate_limit(2)||abs(imag(EIG.eigenvalue_unique(ss)))<EIG.Omega_limit(1)||abs(imag(EIG.eigenvalue_unique(ss)))>EIG.Omega_limit(2) )
        cal=cal+1;
        s_null(cal)=ss;
    end
end
EIG.eigenvalue_unique(s_null)=[];        % Do not use semicolon since I want to show the final value
E = EIG.eigenvalue_unique; 
clear EIG
%
% ----------------------------Calculate contour values---------------------
%
function F = Fcn_calculation_contour
global CI
%
n   = length(CI.EIG.Cont.GRSp);
m   = length(CI.EIG.Cont.FreqSp);
F   = zeros(n,m);
for ss = 1:n
    GR = CI.EIG.Cont.GRSp(ss);
    for kk  = 1:m
        omega       = 2*pi*CI.EIG.Cont.FreqSp(kk);
        s           = GR+1i*omega;
        F(ss,kk)    = Fcn_DetEqn(s);
    end
end
%
% -------------------------end---------------------------------------------    
