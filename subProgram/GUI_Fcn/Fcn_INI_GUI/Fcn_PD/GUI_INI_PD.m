function varargout = GUI_INI_PD(varargin)
% GUI_INI_PD MATLAB code for GUI_INI_PD.fig
%      GUI_INI_PD, by itself, creates a new GUI_INI_PD or raises the existing
%      singleton*.
%
%      H = GUI_INI_PD returns the handle to a new GUI_INI_PD or the handle to
%      the existing singleton*.
%
%      GUI_INI_PD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INI_PD.M with the given input arguments.
%
%      GUI_INI_PD('Property','Value',...) creates a new GUI_INI_PD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_INI_PD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_INI_PD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_INI_PD

% Last Modified by GUIDE v2.5 30-Mar-2015 19:04:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_INI_PD_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_INI_PD_OutputFcn, ...
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

% --- Executes just before GUI_INI_PD is made visible.
function GUI_INI_PD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_INI_PD (see VARARGIN)
%--------------------------------------------------------------------------
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_INI_CD (see VARARGIN)
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
            handles.output = hObject;
            % Initialization
            GUI_INI_PD_Initialization(hObject, eventdata, handles)
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
%            uiwait(hObject);
        end
    case 1
        addpath(genpath('./'))                    % add directories to search path
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
        CI.IsRun.GUI_INI_TP = 0;
        assignin('base','CI',CI);                   % save the current information to the works
        guidata(hObject, handles);  
        GUI_INI_PD_Initialization(hObject, eventdata, handles)
        handles = guidata(hObject);
        guidata(hObject, handles);
        handles.output = hObject;
        guidata(hObject, handles);
end

function GUI_INI_PD_Initialization(varargin)
hObject = varargin{1};
handles = guidata(hObject);
%--------------------------------------------------------------------------
global CI
CI.CD.x_sample_input = CI.CD.x_sample;                
CI.CD.r_sample_input = CI.CD.r_sample;
CI.CD.SectionIndex_input    = CI.CD.SectionIndex;
CI.CD.TubeIndex_input    = CI.CD.TubeIndex;

idExistHR=any(strcmp('NUM_HR',fieldnames(CI.CD)));
idExistLiner=any(strcmp('NUM_Liner',fieldnames(CI.CD)));

if idExistHR==0
CI.CD.NUM_HR_input      = 0;
CI.CD.HR_config_input   = [];
else
CI.CD.NUM_HR_input      = CI.CD.NUM_HR;
CI.CD.HR_config_input   = CI.CD.HR_config;
end

if idExistLiner==0
CI.CD.NUM_Liner_input      = 0;
CI.CD.Liner_config_input   = [];
else
CI.CD.NUM_Liner_input      = CI.CD.NUM_Liner;
CI.CD.Liner_config_input   = CI.CD.Liner_config;
end
assignin('base','CI',CI);                   % save the current information to the works

%--------------------------------------
% positions reconfiguration
set(0, 'units', 'points');
screenSize  = get(0, 'ScreenSize');                 % get the screen size
sW          = handles.sW;                           % screen width
sH          = handles.sH ;                          % screen height
FigW=sW.*2/3;                                        % window width
FigH=sH.*2/3;                                        % window height
set(handles.figure,     'units', 'points',...
                        'position',[(screenSize(3)-FigW)./2 (screenSize(4)-FigH)./2 FigW FigH],...
                        'name','Damper configurations',...
                        'color',handles.bgcolor{3},...
                        'ToolBar','none');
%----------------------------------------
% pannel axes
set(handles.uipanel_axes,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*11/20 FigW*19/20 FigH*8.75/20],...
                        'Title','Combustor shape preview',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize = get(handles.uipanel_axes,'position');
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.axes1,      'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.75/10 pH*2.5/10 pW*6.5/10 pH*5.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1});                      
%----------------------------------------
% Update handles structure
guidata(hObject, handles);
handles = guidata(hObject);
Fcn_CD_plot_with_dampers(handles.axes1,handles,1);        % draw the combustor shape
%----------------------------------------
% pannels damper style
set(handles.uipanel_Damper_type,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*8.5/20 FigW*9.5/20 FigH*2.0/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});
pannelsize=get(handles.uipanel_Damper_type,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_Damper_TYPE,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*2.5/10 pW*4.5/10 pH*4/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Damper type:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.pop_Damper_type,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5/10 pH*3/10 pW*4.5/10 pH*4/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{  'Helmholtz resonator';...
                                    'Perforated liner'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1);  
%----------------------------------------
% pannels HR model
set(handles.uipanel_HR_model,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*10/20 FigH*8.5/20 FigW*9.5/20 FigH*2.0/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});
pannelsize=get(handles.uipanel_HR_model,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_HR_model,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*2.5/10 pW*4.5/10 pH*4/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','HR model:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.pop_HR_model,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5/10 pH*3/10 pW*4.5/10 pH*4/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'Linear';...
                                   'Nonlinear'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1);  

%----------------------------------------
% pannels damper configuration
set(handles.uipanel_HR_setting,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*2.5/20 FigW*9.5/20 FigH*6.05/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_HR_setting,'position');
pW=pannelsize(3);
pH=pannelsize(4);   
set(handles.text_HR_L,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*7.7/10 pW*4.5/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Location [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');

set(handles.text_HR_NL,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*5.2/10 pW*4.5/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Neck length [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.text_HR_NA,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*2.7/10 pW*4.5/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Neck area [mm^2]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');   
set(handles.text_HR_CV,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*0.3/10 pW*6/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Cavity volume [mm^3]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.ed_HR_L,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6/10 pH*7.7/10 pW*3.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',400,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');
set(handles.ed_HR_NL,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6/10 pH*5.2/10 pW*3.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',36.15,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');  
set(handles.ed_HR_NA,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6/10 pH*2.7/10 pW*3.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',235,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right'); 
set(handles.ed_HR_CV,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6/10 pH*0.2/10 pW*3.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',420000,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');   
%---------------------------------------------------------                    
% Pannels HR model configurations
% Linear
set(handles.uipanel_HR_Linear,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*10/20 FigH*2.5/20 FigW*9.5/20 FigH*6.05/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});
pannelsize=get(handles.uipanel_HR_Linear,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_HR_Mean_hole_Mach,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*1/10 pW*6/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Mean hole Mach no.:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_HR_Mean_hole_Mach,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*7/10 pH*1/10 pW*2.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0.01,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right'); 
set(handles.text_Cavity_temperature,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*5.0/10 pW*6/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Cavity Temperaure (K):',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_Cavity_temperature,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*7/10 pH*5.0/10 pW*2.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',293.15,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right'); 
                    
                    
                   
% Nonlinear
set(handles.uipanel_HR_nonlinear_model,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*10/20 FigH*2.5/20 FigW*9.5/20 FigH*6.05/20],...
                        'Title','',...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});
pannelsize=get(handles.uipanel_HR_nonlinear_model,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_HR_discharge_coefficient,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*1/10 pW*6/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Discharge coefficient:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_HR_discharge_coefficient,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*7/10 pH*1/10 pW*2.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0.819,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right'); 
set(handles.text_Cavity_temperature_nonliner,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*5.0/10 pW*6/10 pH*1.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Cavity Temperaure (K):',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_Cavity_temperature_nonlinear,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*7/10 pH*5.0/10 pW*2.5/10 pH*2/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',293.15,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right'); 

                    
%----------------------------------------
% pannels Liner type
set(handles.uipanel_Liner_type,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*10/20 FigH*8.5/20 FigW*9.5/20 FigH*2.0/20],...
                        'Title','',...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});
pannelsize=get(handles.uipanel_Liner_type,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_Liner_type,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*2.5/10 pW*4.5/10 pH*4/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Liner type:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                          
set(handles.pop_Liner_type,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5/10 pH*3/10 pW*4.5/10 pH*4/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'Single liner';...
                                  'Double liner'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1);
                    
                    
%----------------------------------------
% pannels perforated liner configuration                
set(handles.uipanel_Liner,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*6.13/20 FigW*19.0/20 FigH*2.42/20],...
                        'Title','',...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});                   
pannelsize=get(handles.uipanel_Liner,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
set(handles.text_LINER_L,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*5.0/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Start location [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');
set(handles.ed_LINER_L,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3/10 pH*5.0/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',400,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');

set(handles.text_LINER_Length,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Length [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 


set(handles.ed_LINER_Length,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8/10 pH*5.0/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',177.5,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right'); 
% Liner temperature
set(handles.text_Liner_Temperature,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*0.125/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Liner temperature (K):',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_Liner_Temperature,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3/10 pH*0.125/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',293.15,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');
% Liner outside boundary
set(handles.text_Liner_outside_boundary,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*0.125/10 pW*2/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Outside boundary:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.pop_Liner_outside_boundary,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.02/10 pH*0.125/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'Large cavity';...
                                  'Rigid wall'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pannels set outside rigid wall radius                   
set(handles.uipanel_outside_wall_configuration,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*11/20 FigH*4.9805/20 FigW*7.6/20 FigH*1.089/20],...
                        'Title',get(handles.uipanel_Liner,'Title'),...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',0,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});                   
pannelsize=get(handles.uipanel_outside_wall_configuration,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
set(handles.text_outside_wall_radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0/10 pH*0/10 pW*5/10 pH*5/6],...
                        'fontsize',handles.FontSize(2),...
                        'string','Wall radius [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.edit_outside_wall_radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6.25/10 pH*0/10 pW*3.75/10 pH*10/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',90,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right',...
                        'enable','on',...
                        'value',1); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pannels choose liner layer for the double liners                   
set(handles.uipanel_double_liner_layer_choose,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*4.9805/20 FigW*9.05/20 FigH*1.089/20],...
                        'Title',get(handles.uipanel_Liner,'Title'),...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',0,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});                   
pannelsize=get(handles.uipanel_double_liner_layer_choose,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
set(handles.text_choose_liner,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.525/10 pH*0/10 pW*5/10 pH*5/6],...
                        'fontsize',handles.FontSize(2),...
                        'string','Liner layer:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');                         
set(handles.pop_choose_liner_layer,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*6.4/10 pH*0/10 pW*3.15/10 pH*10/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{'First layer';...
                                  'Second layer'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on',...
                        'value',1); 
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Panel double liners configuration 1                  
set(handles.uipanel_double_liner_config_1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*2.5/20 FigW*19/20 FigH*2.42/20],...
                        'Title',get(handles.uipanel_Liner,'Title'),...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});                   
pannelsize=get(handles.uipanel_double_liner_config_1,'position');
pW=pannelsize(3);
pH=pannelsize(4);  
set(handles.text_First_LINER_hole_Radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Hole radius [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_First_LINER_hole_Radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.0/10 pH*5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0.375,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');
set(handles.text_First_liner_hole_distance,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Hole distance [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_First_liner_hole_distance,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.0/10 pH*5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',3.3,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');
set(handles.text_First_liner_Mach,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*0.5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Hole mean Mach no.:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_First_liner_Mach,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.0/10 pH*0.5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0.009,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                     
set(handles.text_First_liner_thickness,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*0.5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Thickness [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_First_liner_thickness,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.0/10 pH*0.5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',4.243,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right'); 
% Double liners configuration 2                  
set(handles.uipanel_double_liner_config_2,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*2.5/20 FigW*19/20 FigH*2.42/20],...
                        'Title',get(handles.uipanel_Liner,'Title'),...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});                   
pannelsize=get(handles.uipanel_double_liner_config_2,'position');
pW=pannelsize(3);
pH=pannelsize(4);
set(handles.text_Second_LINER_Radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*0.5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Layer radius [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.ed_Second_LINER_radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.0/10 pH*0.5/10 pW*1.5/10 pH*4.5/10],...                      
                        'fontsize',handles.FontSize(2),...
                        'string',76,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                    
set(handles.text_Second_liner_hole_distance,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Hole distance [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_Second_liner_hole_distance,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.0/10 pH*5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',17,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                    
set(handles.text_Second_LINER_hole_Radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*5/10 pW*2.5/10 pH*3.75/10],... 
                        'fontsize',handles.FontSize(2),...
                        'string','Hole radius [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_Second_LINER_hole_Radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.0/10 pH*5/10 pW*1.5/10 pH*4.5/10],... 
                        'fontsize',handles.FontSize(2),...
                        'string',1.35,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                   
set(handles.text_Second_Liner_thickness,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*0.5/10 pW*2.5/10 pH*3.7/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Thickness [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_Second_liner_thickness,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.0/10 pH*0.5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',3,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
% Single liners configuration                  
set(handles.uipanel_single_liner_configuration,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*2.5/20 FigW*19/20 FigH*2.42/20],...
                        'Title',get(handles.uipanel_Liner,'Title'),...
                        'visible','off',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});                   
pannelsize=get(handles.uipanel_single_liner_configuration,'position');
pW=pannelsize(3);
pH=pannelsize(4); 
set(handles.text_single_liner_hole_radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Hole radius [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_single_liner_hole_radius,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.0/10 pH*5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0.3,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                   
set(handles.text_single_liner_hole_distance,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Hole distance [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_single_liner_hole_distance,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.0/10 pH*5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',3,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                    
set(handles.text_single_liner_hole_Mach,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.25/10 pH*0.5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Hole mean Mach no.:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_single_liner_hole_Mach,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*3.0/10 pH*0.5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',0.003,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                    
set(handles.text_single_liner_thickness,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.5/10 pH*0.5/10 pW*2.5/10 pH*3.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Thickness [mm]:',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left'); 
set(handles.edit_single_liner_thickness,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*8.0/10 pH*0.5/10 pW*1.5/10 pH*4.5/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',3,...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','right');                    

%----------------------------------------
% pannel AOC                    
set(handles.uipanel_AOC,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*0/20 FigW*19/20 FigH*2/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_AOC,'position');                    
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.pb_Add,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.4/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Add',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_SaveFig,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*2.8/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Save figure',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_OK,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*5.2/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Finish',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_Cancel,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*7.6/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Cancel',...
                        'backgroundcolor',handles.bgcolor{3}); 
guidata(hObject, handles);
%--------------------------------------------------------------------------


% --- Outputs from this function are returned to the command line.
function varargout = GUI_INI_PD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
% varargout{1} = [];
% delete(hObject);
try
varargout{1} = handles.output;
end

%--- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(hObject);



% --- Executes on selection change in pop_Damper_type.
function pop_Damper_type_Callback(hObject, eventdata, handles)
% hObject    handle to pop_Damper_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pop_Damper_type=get(handles.pop_Damper_type,'Value');

switch pop_Damper_type
    case 1
        set(handles.uipanel_HR_setting,   'visible','on');
        set(handles.uipanel_HR_model,     'visible', 'on');
        set(handles.uipanel_HR_Linear,  'visible', 'on');
        set(handles.uipanel_HR_nonlinear_model,    'visible', 'off');
        set(handles.uipanel_Liner,        'visible','off');
        set(handles.uipanel_outside_wall_configuration,    'visible', 'off');
        set(handles.uipanel_double_liner_config_2,    'visible', 'off');
        set(handles.uipanel_double_liner_config_1,    'visible', 'off');
        set(handles.uipanel_double_liner_layer_choose,    'visible', 'off');
        set(handles.uipanel_single_liner_configuration,    'visible', 'off');
        set(handles.uipanel_Liner_type,     'visible', 'off');
  
    case 2
        set(handles.uipanel_HR_setting,   'visible','off');
        set(handles.uipanel_HR_model,     'visible', 'off');
        set(handles.uipanel_HR_Linear,    'visible', 'off');
        set(handles.uipanel_HR_nonlinear_model,    'visible', 'off');
        set(handles.uipanel_outside_wall_configuration,    'visible', 'off');
        set(handles.uipanel_double_liner_config_2,    'visible', 'off');
        set(handles.uipanel_double_liner_config_1,    'visible', 'off');
        set(handles.uipanel_double_liner_layer_choose,    'visible', 'off');
        set(handles.uipanel_Liner_type,     'visible', 'on');
        set(handles.uipanel_single_liner_configuration,    'visible', 'on');
        set(handles.uipanel_Liner,        'visible','on');

 end
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns pop_Damper_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_Damper_type


% --- Executes during object creation, after setting all properties.
function pop_Damper_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_Damper_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ed_LINER_L_Callback(hObject, eventdata, handles)
% hObject    handle to ed_LINER_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Hints: get(hObject,'String') returns contents of ed_LINER_L as text
%        str2double(get(hObject,'String')) returns contents of ed_LINER_L as a double


% --- Executes during object creation, after setting all properties.
function ed_LINER_L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_LINER_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_LINER_Length_Callback(hObject, eventdata, handles)
% hObject    handle to ed_LINER_Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Hints: get(hObject,'String') returns contents of ed_LINER_Length as text
%        str2double(get(hObject,'String')) returns contents of ed_LINER_Length as a double


% --- Executes during object creation, after setting all properties.
function ed_LINER_Length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_LINER_Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
CI.IsRun.GUI_INI_PD = 1;
Fcn_Interface_location
Fcn_GUI_INI_PD_Update_Main_GUI(hObject);
assignin('base','CI',CI); 
delete(handles.figure);

% --- Executes on button press in pb_Add.
function pb_Add_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fcn_GUI_INI_CD_Update_Data(hObject, eventdata, handles);
handles = guidata(hObject);
guidata(hObject, handles);
Fcn_CD_plot_with_dampers(handles.axes1,handles,1);        % draw the combustor shape   


% --- Executes on button press in pb_SaveFig.
function pb_SaveFig_Callback(hObject, eventdata, handles)
% hObject    handle to pb_SaveFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
Fig = figure;
set(Fig,        'units','points')
posFig = get(handles.figure,'position');
copyobj(handles.axes1, Fig);
hAxes = get(Fig,'children');
set(hAxes,      'units','points',...
                'position',[60 60 400 150])
posAxesOuter = [0 0 500 250];
set(Fig,        'units','points',...
                'position', [posFig(1)+0.5*posFig(3)-0.5*posAxesOuter(3),...
                            posFig(2)+0.5*posFig(4)-0.5*posAxesOuter(4),...
                            posAxesOuter(3:4)]) 

% --- Executes on button press in pb_Cancel.
function pb_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
CI.CD.x_sample    = CI.CD.x_sample_input;                
CI.CD.r_sample    = CI.CD.r_sample_input;
CI.CD.SectionIndex       = CI.CD.SectionIndex_input;
CI.CD.TubeIndex          = CI.CD.TubeIndex_input;
CI.CD.NUM_HR      = CI.CD.NUM_HR_input;
CI.CD.NUM_Liner   = CI.CD.NUM_Liner_input;
CI.CD.HR_config   = CI.CD.HR_config_input;
CI.CD.Liner_config= CI.CD.Liner_config_input;
assignin('base','CI',CI);                   % save the current information to the workspace
Fcn_CD_plot_with_dampers(handles.axes1,handles,1);        % draw the combustor shape


% --- Update the data when clicking 'OK' or 'Apply'
function Fcn_GUI_INI_CD_Update_Data(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
idExistHR = any(strcmp('HR_config',fieldnames(CI.CD)));
% ------------------------------------------------------------
%%% to see if the number of HR is changed!!! by JLI 20150411
switch idExistHR
    case 0          
        NumHR1 = 0;
    case 1
        if isempty(CI.CD.HR_config) == 1
            NumHR1 = 0;
        else
            temp = size(CI.CD.HR_config);
            NumHR1 = temp(1);
        end
end
% ------------------------------------------------------------
CI.CD.pop_Damper_type=get(handles.pop_Damper_type,'Value');
x_sample     =CI.CD.x_sample;                
r_sample     =CI.CD.r_sample;
SectionIndex        =CI.CD.SectionIndex;
TubeIndex           =CI.CD.TubeIndex;
NUM_HR                   =CI.CD.NUM_HR;
NUM_Liner                =CI.CD.NUM_Liner;
HR_config_base      =CI.CD.HR_config;
Liner_config_base   =CI.CD.Liner_config;

         switch CI.CD.pop_Damper_type
               
            case 1
                L_HR=str2num(get(handles.ed_HR_L,'string'))/1000;
                % Check if the location is appropriate
                
                % Distance to the nearest section
                HR_section_distance=min(abs(L_HR-x_sample));    
                % Distance to the nearest HR
                if NUM_HR==0
                    HR_HR_distance=10^3;
                else
                    HR_HR_distance=min(abs(L_HR-HR_config_base(:,2)));
                end
                % Distance to the nearest Liner
                if NUM_Liner==0
                    HR_Liner_distance=10^3;
                else
                    HR_Liner_distance=min(min(abs(L_HR-Liner_config_base(:,2))), min(abs(L_HR-Liner_config_base(:,2)-Liner_config_base(:,3))));
                end
                HR_HR_Liner_distance=min(HR_HR_distance,HR_Liner_distance);
            if  HR_section_distance<abs(max(x_sample)-min(x_sample))/100.1 || HR_HR_Liner_distance<abs(max(x_sample)-min(x_sample))/40.1 || L_HR>=max(x_sample) || L_HR<=min(x_sample)
                   errordlg('Inappropriate HR location','Error');
            else
                NUM_samples=length(x_sample);
                % Find the location of the HR
                Index_loop=1;
                while L_HR>x_sample(Index_loop)
                    Index_loop=Index_loop+1;
                end 
                % Add one sample section in the data
                for Index_change=Index_loop:1:NUM_samples
                    x_sample(NUM_samples-(Index_change-Index_loop)+1)=x_sample(NUM_samples-(Index_change-Index_loop));
                    r_sample(NUM_samples-(Index_change-Index_loop)+1)=r_sample(NUM_samples-(Index_change-Index_loop));
                    SectionIndex(NUM_samples-(Index_change-Index_loop)+1)=SectionIndex(NUM_samples-(Index_change-Index_loop));
                    TubeIndex(NUM_samples-(Index_change-Index_loop)+1)=TubeIndex(NUM_samples-(Index_change-Index_loop));
                end
                x_sample(Index_loop)=L_HR;
                r_sample(Index_loop)=r_sample(Index_loop-1);
                SectionIndex(Index_loop)=2;
                TubeIndex(Index_loop)=0;
                % Find parameters of the HR
                HR_Location=L_HR;
                HR_CI.CD.SectionIndexength=str2num(get(handles.ed_HR_NL,'string'))/1000;
                HR_Neck_Area=str2num(get(handles.ed_HR_NA,'string'))/1000^2;
                HR_Cavity_volum=str2num(get(handles.ed_HR_CV,'string'))/1000^3;
                % Check the HR model
                CI.CD.pop_HR_model=get(handles.pop_HR_model,'Value');
                switch CI.CD.pop_HR_model
                    case 1
                       HR_type=0;  % Linear HR
                       HR_Cavity_temperature=str2num(get(handles.edit_Cavity_temperature,'string'));
                       HR_Mean_Hole_Mach=str2num(get(handles.edit_HR_Mean_hole_Mach,'string'));
                       HR_discharge_coefficient=0;
                    case 2
                       HR_type=1;  % Nonlinear HR
                       HR_Cavity_temperature=str2num(get(handles.edit_Cavity_temperature_nonlinear,'string'));
                       HR_discharge_coefficient=str2num(get(handles.edit_HR_discharge_coefficient,'string'));
                       HR_Mean_Hole_Mach=0;
                    otherwise
                        % Unlikely to happen
                end
                NUM_HR=NUM_HR+1;
                HR_config=[NUM_HR, HR_Location, HR_type, HR_CI.CD.SectionIndexength, HR_Neck_Area, HR_Cavity_volum, HR_Cavity_temperature, HR_Mean_Hole_Mach, HR_discharge_coefficient];
                % Update the HR configuration data 
                if NUM_HR==1
                   CI.CD.HR_config(NUM_HR,:)  =HR_config;
                   else if NUM_HR>1
                   % Find the location of this HR in the HR_config list
                           HR_Location_count=1;
                           while HR_Location_count<NUM_HR && HR_config(1,2)>CI.CD.HR_config(HR_Location_count,2) 
                           HR_Location_count=HR_Location_count+1;
                           end
                           % Add the new HR parameters into the list and renew the order of
                           % the list according to the location of the new HR
                           if HR_Location_count==NUM_HR
                              CI.CD.HR_config(NUM_HR,:)  =HR_config;
                           else
                             for Loop_num=HR_Location_count:1:(NUM_HR-1)
                                 CI.CD.HR_config(NUM_HR-(Loop_num-HR_Location_count),:)  =CI.CD.HR_config(NUM_HR-(Loop_num-HR_Location_count)-1,:);
                                 CI.CD.HR_config(NUM_HR-(Loop_num-HR_Location_count),1)  =CI.CD.HR_config(NUM_HR-(Loop_num-HR_Location_count),1)+1;
                             end
                                 CI.CD.HR_config(HR_Location_count,:)  =HR_config;
                                 CI.CD.HR_config(HR_Location_count,1)  =HR_Location_count;
                           end
                       end
                end
                CI.CD.NUM_HR=NUM_HR; 
            end
            
            case 2
                L_Liner=str2num(get(handles.ed_LINER_L,'string'))/1000;
                L_length_Liner=str2num(get(handles.ed_LINER_Length,'string'))/1000;
                Liner_temperature=str2num(get(handles.edit_Liner_Temperature,'string'));

                NUM_samples=length(x_sample);
                % Find the location of the Liner
                Index_loop=1;
                while L_Liner>x_sample(Index_loop)
                    Index_loop=Index_loop+1;
                end 
                % Check if the location is appropriate
                
                % Distance to the nearest section
                Liner_section_distance=min(min(abs(L_Liner-x_sample)), min(abs(L_Liner+L_length_Liner-x_sample)));    
                % Distance to the nearest HR
                if NUM_Liner==0
                    Liner_Liner_distance=10^3;
                else
                    Liner_Liner_distance=min(min(abs(L_Liner-Liner_config_base(:,2))), min(abs(L_Liner+L_length_Liner-Liner_config_base(:,2))));
                end
                % Distance to the nearest Liner
                if NUM_HR==0
                    Liner_HR_distance=10^3;
                else
                    Liner_HR_distance=min(min(abs(L_Liner-HR_config_base(:,2))), min(abs(L_Liner+L_length_Liner-HR_config_base(:,2))));
                end
                
                Liner_Liner_HR_distance=min(Liner_Liner_distance,Liner_HR_distance);
                Liner_outside_wall_radius=str2num(get(handles.edit_outside_wall_radius,'string'))/1000;
                
                % Check the Liner model
                CI.CD.pop_Liner_type=get(handles.pop_Liner_type,'Value');
                CI.CD.pop_Liner_outside_boundary=get(handles.pop_Liner_outside_boundary,'Value');
                
                switch CI.CD.pop_Liner_type
                        case 1   % Single Liner
                           Inner_Liner_radius=r_sample(Index_loop)+str2num(get(handles.edit_single_liner_thickness,'string'))/1000;
                        case 2   % Double Liner
                           Inner_Liner_radius=str2num(get(handles.ed_Second_LINER_radius,'string'))/1000+str2num(get(handles.edit_Second_liner_thickness,'string'))/1000;
                        otherwise
                        % Unlikely to happen
                end

             if  L_length_Liner>(x_sample(Index_loop)-L_Liner) || Liner_section_distance<(max(x_sample)-min(x_sample))*1/100.1 || Liner_Liner_HR_distance<(max(x_sample)-min(x_sample))/50.1 ||L_Liner<=0 || L_Liner>=max(x_sample) || L_length_Liner<=0
                   errordlg('Inappropriate liner location','Error');
             else if  Liner_outside_wall_radius <= Inner_Liner_radius
                     errordlg('The rigid wall radius is too small','Error');                  
                 else
                % Add two sample sections in the data
                for Index_change=Index_loop:1:NUM_samples
                    x_sample(NUM_samples-(Index_change-Index_loop)+2)=x_sample(NUM_samples-(Index_change-Index_loop));
                    r_sample(NUM_samples-(Index_change-Index_loop)+2)=r_sample(NUM_samples-(Index_change-Index_loop));
                    SectionIndex(NUM_samples-(Index_change-Index_loop)+2)=SectionIndex(NUM_samples-(Index_change-Index_loop));
                    TubeIndex(NUM_samples-(Index_change-Index_loop)+2)=TubeIndex(NUM_samples-(Index_change-Index_loop));
                end
                x_sample(Index_loop+1)=L_Liner+L_length_Liner;
                r_sample(Index_loop+1)=r_sample(Index_loop-1);
                SectionIndex(Index_loop+1)=31;
                TubeIndex(Index_loop+1)=0;
                
                x_sample(Index_loop)=L_Liner;
                r_sample(Index_loop)=r_sample(Index_loop-1);
                SectionIndex(Index_loop)=30;
                TubeIndex(Index_loop)=2;
                
                % Find parameters of the Liner
                Liner_Location=L_Liner;
                Liner_Length=L_length_Liner;

                switch CI.CD.pop_Liner_type
                    case 1
                       Liner_type=0;  %  Single Liner
                       Single_liner_hole_radius=str2num(get(handles.edit_single_liner_hole_radius,'string'))/1000;
                       Single_liner_hole_distance=str2num(get(handles.edit_single_liner_hole_distance,'string'))/1000;
                       Single_liner_hole_Mach=str2num(get(handles.edit_single_liner_hole_Mach,'string'));
                       Single_liner_thickness=str2num(get(handles.edit_single_liner_thickness,'string'))/1000;
                       
                       % The unused parameters are set to zeros
                       Double_First_liner_hole_Radius=0;
                       Double_First_liner_hole_distance=0;
                       Double_First_liner_Mach=0;
                       Double_First_liner_thickness=0;
                       
                       Double_Second_liner_hole_Radius=0;
                       Double_Second_liner_hole_distance=0;
                       Double_Second_liner_radius=0;
                       Double_Second_liner_thickness=0; 

                    case 2
                       Liner_type=1;  % Double Liner
                       Double_First_liner_hole_Radius=str2num(get(handles.edit_First_LINER_hole_Radius,'string'))/1000;
                       Double_First_liner_hole_distance=str2num(get(handles.edit_First_liner_hole_distance,'string'))/1000;
                       Double_First_liner_Mach=str2num(get(handles.edit_First_liner_Mach,'string'));
                       Double_First_liner_thickness=str2num(get(handles.edit_First_liner_thickness,'string'))/1000;
                       
                       Double_Second_liner_hole_Radius=str2num(get(handles.edit_Second_LINER_hole_Radius,'string'))/1000;
                       Double_Second_liner_hole_distance=str2num(get(handles.edit_Second_liner_hole_distance,'string'))/1000;
                       Double_Second_liner_radius=str2num(get(handles.ed_Second_LINER_radius,'string'))/1000;
                       Double_Second_liner_thickness=str2num(get(handles.edit_Second_liner_thickness,'string'))/1000;
                       
                       % The unused parameters are set to zeros
                       Single_liner_hole_radius=0;
                       Single_liner_hole_distance=0;
                       Single_liner_hole_Mach=0;
                       Single_liner_thickness=0;
                    otherwise
                        % Unlikely to happen
                end
                % Liner outside boundary
                switch CI.CD.pop_Liner_outside_boundary
                    case 1
                       Liner_outside_boundary=0;  %  Large cavity
                       Liner_outside_wall_radius=0;
                    case 2
                       Liner_outside_boundary=1;  % Rigid wall
                       Liner_outside_wall_radius=str2num(get(handles.edit_outside_wall_radius,'string'))/1000;
                    otherwise
                        % Unlikely to happen       
                end
                
                NUM_Liner=NUM_Liner+1;
                
                Liner_config=[NUM_Liner, Liner_Location, Liner_Length, Liner_type, Liner_outside_boundary, Liner_outside_wall_radius, Liner_temperature, Single_liner_hole_radius, Single_liner_hole_distance, Single_liner_hole_Mach, Single_liner_thickness, Double_First_liner_hole_Radius, Double_First_liner_hole_distance, Double_First_liner_Mach, Double_First_liner_thickness, Double_Second_liner_hole_Radius, Double_Second_liner_hole_distance, Double_Second_liner_radius, Double_Second_liner_thickness];
                
                % Update the Liner configuration data 
                if NUM_Liner==1
                   CI.CD.Liner_config(NUM_Liner,:)  =Liner_config;
                   else if NUM_Liner>1
                   % Find the location of this Liner in the Liner_config list
                           Liner_Location_count=1;
                           while Liner_Location_count<NUM_Liner && Liner_config(1,2)>CI.CD.Liner_config(Liner_Location_count,2) 
                           Liner_Location_count=Liner_Location_count+1;
                           end
                           % Add the new Liner parameters into the list and renew the order of
                           % the list according to the location of the new Liner
                           if Liner_Location_count==NUM_Liner
                              CI.CD.Liner_config(NUM_Liner,:)  =Liner_config;
                           else
                             for Loop_num=Liner_Location_count:1:(NUM_Liner-1)
                                 CI.CD.Liner_config(NUM_Liner-(Loop_num-Liner_Location_count),:)  =CI.CD.Liner_config(NUM_Liner-(Loop_num-Liner_Location_count)-1,:);
                                 CI.CD.Liner_config(NUM_Liner-(Loop_num-Liner_Location_count),1)  =CI.CD.Liner_config(NUM_Liner-(Loop_num-Liner_Location_count),1)+1;
                             end           
                                 CI.CD.Liner_config(Liner_Location_count,:)  =Liner_config;
                                 CI.CD.Liner_config(Liner_Location_count,1)  =Liner_Location_count;
                           end
                       end
                end
                CI.CD.NUM_Liner=NUM_Liner; 
                 end  
            end
            
                % code for when there is no match
             otherwise
         end
% Update data for the system       
CI.CD.x_sample   =x_sample;                
CI.CD.r_sample   =r_sample;
CI.CD.SectionIndex      =SectionIndex;
CI.CD.TubeIndex         =TubeIndex;
% ------------------------------------------------------------
%%% to see if the number of HR is changed!!! by JLI 20150411
switch idExistHR
    case 0          
        NumHR2 = 0;
    case 1
        if isempty(CI.CD.HR_config) == 1
            NumHR2 = 0;
        else
            temp = size(CI.CD.HR_config);
            NumHR2 = temp(1);
        end
end
if NumHR2 ~= NumHR1
    CI.IsRun.GUI_INI_TP = 0;
end
% ------------------------------------------------------------
assignin('base','CI',CI);                   % save the current information to the workspace

guidata(hObject, handles);
%
%-----------------------------------end------------------------------------


function ed_HR_NA_Callback(hObject, eventdata, handles)
% hObject    handle to ed_HR_NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Hints: get(hObject,'String') returns contents of ed_HR_NA as text
%        str2double(get(hObject,'String')) returns contents of ed_HR_NA as a double


% --- Executes during object creation, after setting all properties.
function ed_HR_NA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_HR_NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_HR_NL_Callback(hObject, eventdata, handles)
% hObject    handle to ed_HR_NL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Hints: get(hObject,'String') returns contents of ed_HR_NL as text
%        str2double(get(hObject,'String')) returns contents of ed_HR_NL as a double


% --- Executes during object creation, after setting all properties.
function ed_HR_NL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_HR_NL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_HR_L_Callback(hObject, eventdata, handles)
% hObject    handle to ed_HR_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Hints: get(hObject,'String') returns contents of ed_HR_L as text
%        str2double(get(hObject,'String')) returns contents of ed_HR_L as a double


% --- Executes during object creation, after setting all properties.
function ed_HR_L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_HR_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_HR_CV_Callback(hObject, eventdata, handles)
% hObject    handle to ed_HR_CV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Hints: get(hObject,'String') returns contents of ed_HR_CV as text
%        str2double(get(hObject,'String')) returns contents of ed_HR_CV as a double


% --- Executes during object creation, after setting all properties.
function ed_HR_CV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_HR_CV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_Second_LINER_radius_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Second_LINER_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of ed_Second_LINER_radius as text
%        str2double(get(hObject,'String')) returns contents of ed_Second_LINER_radius as a double


% --- Executes during object creation, after setting all properties.
function ed_Second_LINER_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_Second_LINER_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_First_LINER_hole_Radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_First_LINER_hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_First_LINER_hole_Radius as text
%        str2double(get(hObject,'String')) returns contents of edit_First_LINER_hole_Radius as a double


% --- Executes during object creation, after setting all properties.
function edit_First_LINER_hole_Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_First_LINER_hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Second_LINER_hole_Radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Second_LINER_hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_Second_LINER_hole_Radius as text
%        str2double(get(hObject,'String')) returns contents of edit_Second_LINER_hole_Radius as a double


% --- Executes during object creation, after setting all properties.
function edit_Second_LINER_hole_Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Second_LINER_hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_First_liner_hole_distance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_First_liner_hole_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_First_liner_hole_distance as text
%        str2double(get(hObject,'String')) returns contents of edit_First_liner_hole_distance as a double


% --- Executes during object creation, after setting all properties.
function edit_First_liner_hole_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_First_liner_hole_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Second_liner_hole_distance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Second_liner_hole_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_Second_liner_hole_distance as text
%        str2double(get(hObject,'String')) returns contents of edit_Second_liner_hole_distance as a double


% --- Executes during object creation, after setting all properties.
function edit_Second_liner_hole_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Second_liner_hole_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_First_liner_Mach_Callback(hObject, eventdata, handles)
% hObject    handle to edit_First_liner_Mach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_First_liner_Mach as text
%        str2double(get(hObject,'String')) returns contents of edit_First_liner_Mach as a double


% --- Executes during object creation, after setting all properties.
function edit_First_liner_Mach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_First_liner_Mach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_First_liner_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to edit_First_liner_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_First_liner_thickness as text
%        str2double(get(hObject,'String')) returns contents of edit_First_liner_thickness as a double


% --- Executes during object creation, after setting all properties.
function edit_First_liner_thickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_First_liner_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Second_liner_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Second_liner_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_Second_liner_thickness as text
%        str2double(get(hObject,'String')) returns contents of edit_Second_liner_thickness as a double


% --- Executes during object creation, after setting all properties.
function edit_Second_liner_thickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Second_liner_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_HR_model.
function pop_HR_model_Callback(hObject, eventdata, handles)
% hObject    handle to pop_HR_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pop_HR_model=get(handles.pop_HR_model,'Value');
switch pop_HR_model
            case 1
                set(handles.uipanel_HR_Linear,  'visible', 'on');
                set(handles.uipanel_HR_nonlinear_model,    'visible', 'off');
            case 2
                set(handles.uipanel_HR_Linear,  'visible', 'off');
                set(handles.uipanel_HR_nonlinear_model,    'visible', 'on');
end
% Hints: contents = cellstr(get(hObject,'String')) returns pop_HR_model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_HR_model


% --- Executes during object creation, after setting all properties.
function pop_HR_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_HR_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);



function edit_HR_Mean_hole_Mach_Callback(hObject, eventdata, handles)
% hObject    handle to edit_HR_Mean_hole_Mach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_HR_Mean_hole_Mach as text
%        str2double(get(hObject,'String')) returns contents of edit_HR_Mean_hole_Mach as a double


% --- Executes during object creation, after setting all properties.
function edit_HR_Mean_hole_Mach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_HR_Mean_hole_Mach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_HR_discharge_coefficient_Callback(hObject, eventdata, handles)
% hObject    handle to edit_HR_discharge_coefficient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_HR_discharge_coefficient as text
%        str2double(get(hObject,'String')) returns contents of edit_HR_discharge_coefficient as a double


% --- Executes during object creation, after setting all properties.
function edit_HR_discharge_coefficient_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_HR_discharge_coefficient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_Liner_type.
function pop_Liner_type_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Liner_Temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pop_Liner_type=get(handles.pop_Liner_type,'Value');
pop_Liner_outside_boundary=get(handles.pop_Liner_outside_boundary,'Value');
switch pop_Liner_type
            case 1
                set(handles.uipanel_single_liner_configuration,  'visible', 'on');
                set(handles.uipanel_double_liner_layer_choose,    'visible', 'off');
                set(handles.uipanel_double_liner_config_1,    'visible', 'off');
                set(handles.uipanel_double_liner_config_2,    'visible', 'off');
                switch pop_Liner_outside_boundary
                    case 1
                        set(handles.uipanel_outside_wall_configuration, 'visible', 'off');
                    case 2
                        set(handles.uipanel_outside_wall_configuration, 'visible', 'on');
                end
            case 2
                set(handles.uipanel_single_liner_configuration,  'visible', 'off');
                set(handles.uipanel_double_liner_layer_choose,    'visible', 'on');
                set(handles.uipanel_double_liner_config_1,    'visible', 'on');
                set(handles.uipanel_double_liner_config_2,    'visible', 'off');
                switch pop_Liner_outside_boundary
                    case 1
                        set(handles.uipanel_outside_wall_configuration, 'visible', 'off');
                    case 2
                        set(handles.uipanel_outside_wall_configuration, 'visible', 'on');
                end
end
% Hints: contents = cellstr(get(hObject,'String')) returns edit_Liner_Temperature contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_Liner_Temperature


% --- Executes during object creation, after setting all properties.
function pop_Liner_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Liner_Temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_Liner_outside_boundary.
function pop_Liner_outside_boundary_Callback(hObject, eventdata, handles)
% hObject    handle to pop_Liner_outside_boundary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pop_Liner_outside_boundary=get(handles.pop_Liner_outside_boundary,'Value');
switch pop_Liner_outside_boundary
            case 1
                set(handles.uipanel_outside_wall_configuration,    'visible', 'off');   
            case 2
                set(handles.uipanel_outside_wall_configuration,    'visible', 'on');
end
% Hints: contents = cellstr(get(hObject,'String')) returns pop_Liner_outside_boundary contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_Liner_outside_boundary


% --- Executes during object creation, after setting all properties.
function pop_Liner_outside_boundary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_Liner_outside_boundary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noedit_First_liner_thickness_CreateFcnt created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_single_liner_hole_distance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_single_liner_hole_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_single_liner_hole_distance as text
%        str2double(get(hObject,'String')) returns contents of edit_single_liner_hole_distance as a double


% --- Executes during object creation, after setting all properties.
function edit_single_liner_hole_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_single_liner_hole_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_single_liner_hole_Mach_Callback(hObject, eventdata, handles)
% hObject    handle to edit_single_liner_hole_Mach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_single_liner_hole_Mach as text
%        str2double(get(hObject,'String')) returns contents of edit_single_liner_hole_Mach as a double


% --- Executes during object creation, after setting all properties.
function edit_single_liner_hole_Mach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_single_liner_hole_Mach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_single_liner_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to edit_single_liner_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_single_liner_thickness as text
%        str2double(get(hObject,'String')) returns contents of edit_single_liner_thickness as a double


% --- Executes during object creation, after setting all properties.
function edit_single_liner_thickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_single_liner_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_choose_liner_layer.
function pop_choose_liner_layer_Callback(hObject, eventdata, handles)
% hObject    handle to pop_choose_liner_layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pop_choose_liner_layer=get(handles.pop_choose_liner_layer,'Value');
switch pop_choose_liner_layer
            case 1
                set(handles.uipanel_double_liner_config_1,    'visible', 'on');
                set(handles.uipanel_double_liner_config_2,    'visible', 'off');
            case 2
                set(handles.uipanel_double_liner_config_1,    'visible', 'off');
                set(handles.uipanel_double_liner_config_2,    'visible', 'on');
end
% Hints: contents = cellstr(get(hObject,'String')) returns pop_choose_liner_layer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_choose_liner_layer


% --- Executes during object creation, after setting all properties.
function pop_choose_liner_layer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_choose_liner_layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_outside_wall_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outside_wall_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_outside_wall_radius as text
%        str2double(get(hObject,'String')) returns contents of edit_outside_wall_radius as a double


% --- Executes during object creation, after setting all properties.
function edit_outside_wall_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outside_wall_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_single_liner_hole_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Second_LINER_hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_Second_LINER_hole_Radius as text
%        str2double(get(hObject,'String')) returns contents of edit_Second_LINER_hole_Radius as a double


% --- Executes during object creation, after setting all properties.
function edit_single_liner_hole_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Second_LINER_hole_Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Cavity_temperature_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cavity_temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_Cavity_temperature as text
%        str2double(get(hObject,'String')) returns contents of edit_Cavity_temperature as a double


% --- Executes during object creation, after setting all properties.
function edit_Cavity_temperature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cavity_temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Cavity_temperature_nonlinear_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cavity_temperature_nonlinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_Cavity_temperature_nonlinear as text
%        str2double(get(hObject,'String')) returns contents of edit_Cavity_temperature_nonlinear as a double


% --- Executes during object creation, after setting all properties.
function edit_Cavity_temperature_nonlinear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cavity_temperature_nonlinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Liner_Temperature_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Liner_Temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datEdit = str2double(get(hObject, 'String'));
if isnan(datEdit)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Hints: get(hObject,'String') returns contents of edit_Liner_Temperature as text
%        str2double(get(hObject,'String')) returns contents of edit_Liner_Temperature as a double


% --- Executes during object creation, after setting all properties.
function edit_Liner_Temperature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Liner_Temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Fcn_GUI_INI_PD_Update_Main_GUI(varargin)
hObject = varargin{1};
handles = guidata(hObject);
main = handles.MainGUI;
global CI
% Obtain handles using GUIDATA with the caller's handle 
if(ishandle(main))
    mainHandles = guidata(main);
    changeMain = mainHandles.INI_TP;
    set(changeMain, 'Enable', 'on');
    %%%%
    % add: if add damper, CD is not visible!
    changeMain = mainHandles.INI_CD;
    set(changeMain, 'Visible', 'off');
    %%%%
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
    String_Listbox{indStart+1}=['<HTML><FONT color="blue">Information 2:'];
    String_Listbox{indStart+2}=['<HTML><FONT color="blue">Passive dampers:'];
    String_Listbox{indStart+3}=[num2str(CI.CD.NUM_HR) ' Helmholtz resonators and ' num2str(CI.CD.NUM_Liner) ' Liners.'];
    
    set(mainHandles.listbox_Info,'string',String_Listbox,'value',1);
end
guidata(hObject, handles);



%---------------------------------End--------------------------------------
