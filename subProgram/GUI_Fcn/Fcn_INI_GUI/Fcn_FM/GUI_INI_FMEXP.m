function varargout = GUI_INI_FMEXP(varargin)
% GUI_INI_FMEXP MATLAB code for GUI_INI_FMEXP.fig
%      GUI_INI_FMEXP, by itself, creates a new GUI_INI_FMEXP or raises the existing
%      singleton*.
%
%      H = GUI_INI_FMEXP returns the handle to a new GUI_INI_FMEXP or the handle to
%      the existing singleton*.
%
%      GUI_INI_FMEXP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INI_FMEXP.M with the given input arguments.
%
%      GUI_INI_FMEXP('Property','Value',...) creates a new GUI_INI_FMEXP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_INI_FMEXP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_INI_FMEXP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_INI_FMEXP

% Last Modified by GUIDE v2.5 08-Oct-2014 17:36:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_INI_FMEXP_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_INI_FMEXP_OutputFcn, ...
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


% --- Executes just before GUI_INI_FMEXP is made visible.
function GUI_INI_FMEXP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_INI_FMEXP (see VARARGIN)
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
            handles.indexApp = 0;
            GUI_INI_FMEXP_global_value_Initialization
            % Update handles structure
            guidata(hObject, handles);
            % Initialization
            GUI_INI_FMEXP_Initialization(hObject, eventdata, handles)
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
        handles.indexApp = 0;
        CI.FMEXP.indexIMPORT    = 1;
        CI.FMEXP.nFTF           = 0;
        CI.FMEXP.indexModify    = 0;
        assignin('base','CI',CI);                     % save the current information to the works
        GUI_INI_FMEXP_global_value_Initialization
        handles.indexApp = 0;
        guidata(hObject, handles);  
        GUI_INI_FMEXP_Initialization(hObject, eventdata, handles)
        uiwait(hObject);
end


function GUI_INI_FMEXP_global_value_Initialization
global CI
try
    indexExist_CI_FMEXP = any(strcmp('FMEXP',fieldnames(CI)));
    if indexExist_CI_FMEXP == 0;
        CI.FMEXP.indexIMPORT    = 1;
        CI.FMEXP.nFTF           = 0;
        CI.FMEXP.indexModify    = 0;
    end
catch
end
assignin('base','CI',CI);                   % save the current information to the workspace

%-------------------------------------------------
%
function GUI_INI_FMEXP_Initialization(varargin)
global CI
hObject = varargin{1};
handles = guidata(hObject);    
set(0, 'units', 'points');
screenSize  = get(0, 'ScreenSize');                 % get the screen size
sW          = handles.sW;                           % screen width
sH          = handles.sH ;                          % screen height
FigW=sW*4/5;                                        % window width
FigH=sH*5/8;                                        % window height
set(handles.figure,     'units', 'points',...
                        'position',[(screenSize(3)-FigW)./2 (screenSize(4)-FigH)./2 FigW FigH],...
                        'name','Flame model configurations',...
                        'color',handles.bgcolor{3});
%--------------------------------------------------------------------------
% pannel axes
set(handles.uipanel_Axes,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*10.5/20 FigH*2.25/20 FigW*9/20 FigH*17.5/20],...
                        'Title','Plots',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3});  
pannelsize=get(handles.uipanel_Axes,'position');
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.axes1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*2/10 pH*5.0/10 pW*6/10 pH*3.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1},...
                        'box','on');  
set(handles.axes2,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*2/10 pH*1.5/10 pW*6/10 pH*3.5/10],...
                        'fontsize',handles.FontSize(1),...
                        'color',handles.bgcolor{1},...
                        'box','on');  
set(handles.pop_Plot,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.5/10 pH*8.5/10 pW*8/10 pH*1.0/10],...
                        'fontsize',handles.FontSize(2),...
                        'string',{  'Flame describing function'},...
                        'backgroundcolor',handles.bgcolor{1},...
                        'horizontalalignment','left',...
                        'enable','on');                    
guidata(hObject, handles);
%----------------------------------------
% pannels FDFExp
set(handles.uipanel_EXP,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*2.5/20 FigW*9.5/20 FigH*17.25/20],...
                        'Title','Load FDF from experimental results',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_EXP,'position');
pW=pannelsize(3);
pH=pannelsize(4);                  
set(handles.pb_EXP_add,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1/10 pH*2.5/10 pW*8/10 pH*0.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Add FTF for a new velocity ratio',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','right',...
                        'Enable','on');
set(handles.pb_EXP_modify,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1/10 pH*1.5/10 pW*8/10 pH*0.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Edit FTF...',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','right',...
                        'Enable','on');
set(handles.pb_EXP_delete,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1/10 pH*0.5/10 pW*8/10 pH*0.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Delete FTF...',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','right',...
                        'Enable','on');
set(handles.listbox_EXP,...
                        'units', 'points',...
                        'fontunits','points',...
                        'position',[pW*1/10 pH*3.5/10 pW*8/10 pH*5/10],...
                        'fontsize',handles.FontSize(1),...
                        'string','',...
                        'backgroundcolor',handles.bgcolor{4},...
                        'value',[]);  
set(handles.text_EXP_a1,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*1/10 pH*8.5/10 pW*8/10 pH*0.75/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','List of FTFs for different velocity ratios',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'horizontalalignment','left');    
% 
% -------------------------------------
% pannel AOC                   
set(handles.uipanel_AOC,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[FigW*0.5/20 FigH*0/20 FigW*19/20 FigH*1.8/20],...
                        'Title','',...
                        'visible','on',...
                        'highlightcolor',handles.bgcolor{3},...
                        'borderwidth',1,...
                        'fontsize',handles.FontSize(2),...
                        'backgroundcolor',handles.bgcolor{3}); 
pannelsize=get(handles.uipanel_AOC,'position');                    
pW=pannelsize(3);
pH=pannelsize(4);                
set(handles.pb_Apply,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*0.4/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Plot figure',...
                        'backgroundcolor',handles.bgcolor{3});
set(handles.pb_SaveFig,...
                        'units', 'points',...
                        'Fontunits','points',...
                        'position',[pW*2.8/10 pH*2/10 pW*2.0/10 pH*6/10],...
                        'fontsize',handles.FontSize(2),...
                        'string','Save figure',...
                        'backgroundcolor',handles.bgcolor{3},...
                        'enable','off');
set(handles.pb_OK,...
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
%---------------------------------------
handles.ObjVisible_EXP      = findobj('-regexp','Tag','EXP');
set(handles.ObjVisible_EXP,    'visible','on')
guidata(hObject, handles);
Fcn_GUI_INI_FMEXP_Listbox_update(hObject)
guidata(hObject, handles);
Fcn_GUI_INI_FMEXP_Enable(hObject,CI.FMEXP.nFTF)
guidata(hObject, handles);
assignin('base','CI',CI);                   % save the current information to the workspace   
% ------------------------------------------------------------------------

function Fcn_GUI_INI_FMEXP_Enable(hObject,index)
handles = guidata(hObject);
if index == 0
    set(handles.pb_Apply,       'enable','off'); 
    set(handles.pb_SaveFig,     'enable','off'); 
    set(handles.pb_OK,          'enable','off'); 
elseif index > 0 
    set(handles.pb_Apply,       'enable','on'); 
    set(handles.pb_SaveFig,     'enable','on'); 
    set(handles.pb_OK,          'enable','on'); 
end
guidata(hObject, handles);


function Fcn_GUI_INI_FMEXP_Listbox_update(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
try
    for ss = 1:CI.FMEXP.nCount
        uRatio = CI.FMEXP.uRatio(ss);
        String_Listbox{ss} = ['Velocity ratio u''/u_mean = ' num2str(uRatio)];
    end
    set(handles.listbox_EXP,'string',String_Listbox,'value',1);
catch
end
assignin('base','CI',CI);                   % save the current information to the workspace
guidata(hObject, handles);
% ------------------------------------------------------------------------
%
% --- Executes on button press in pb_OK.
function pb_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Fcn_GUI_INI_FM_Update_Data(hObject, eventdata, handles)
global CI
if CI.FMEXP.nFTF>0
    Fcn_GUI_INI_FMEXP_plot(hObject, eventdata, handles)
    Fcn_GUI_INI_FMEXP_Update_Data(hObject, eventdata, handles)
    handles = guidata(hObject);
    set(handles.pb_SaveFig,'enable','on');
    guidata(hObject, handles);
    assignin('base','CI',CI);                   % save the current information to the workspace
    uiresume(handles.figure);
else
    errordlg('No FTF created!','Error');
end
CI.IsRun.GUI_INI_FMEXP = 1;
assignin('base','CI',CI); 

% --- Executes on button press in pb_Apply.
function pb_Apply_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fcn_GUI_INI_FMEXP_plot(hObject, eventdata, handles)
handles = guidata(hObject);
set(handles.pb_SaveFig,'enable','on');
guidata(hObject, handles);
%
% --- Outputs from this function are returned to the command line.
function varargout = GUI_INI_FMEXP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = [];
delete(hObject);
%

function Fcn_GUI_INI_FMEXP_plot(varargin)
hObject     = varargin{1};
handles     = guidata(hObject);
global CI
hAxes1      = handles.axes1;
hAxes2      = handles.axes2;
fontSize1   = handles.FontSize(1);
fontSize2   = handles.FontSize(2);
color_type  = Fcn_color_set(CI.FMEXP.nFTF+2);    % color set
% --------------
try
    cbh = findobj( 0, 'tag', 'Colorbar' );
    delete(cbh)
catch
end
cla(hAxes1,'reset')
axes(hAxes1)
hold on
for ss = 1:CI.FMEXP.nFTF
    Y   = CI.FMEXP.FTF{ss}; 
    hLine = plot(hAxes1,Y.xfit,abs(Y.yfit),'-','color',color_type(ss,1:3),'Linewidth',2);
    xminUD(ss) = 0;
    xmaxUD(ss) = Y.xfit(end);
            set(get(get(hLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','on'); 
            set(hLine,'DisplayName',['$\hat{u}_u/\bar{u}_u=$' num2str(Y.uRatio)])
end
xmin = 0;
xmax = ceil(max(xmaxUD)./100).*100;
set(hAxes1,'YColor','k','Box','on','ygrid','on','xgrid','on');
set(hAxes1,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
xlabel(hAxes1,'','Color','k','Interpreter','LaTex','FontSize',fontSize1);
ylabel(hAxes1,'Gain [-]','Color','k','Interpreter','LaTex','FontSize',fontSize1)
set(hAxes1,'xlim',[xmin xmax],'xTick',0:100:xmax,'xticklabel',{},...
'YAxisLocation','left','Color','w');
hold off
hl=legend('show');
set(hl,'interpreter','latex','Fontsize',handles.FontSize(2),'box','off','Unit','points')
%--------------------------------
cla(hAxes2,'reset')
axes(hAxes2)
hold on
for ss = 1:CI.FMEXP.nFTF
    Y   = CI.FMEXP.FTF{ss}; 
    hLine = plot(hAxes2,Y.xfit,unwrap(angle(Y.yfit),1.9*pi)./pi,...
        '-','color',color_type(ss,1:3),'Linewidth',2);
end
set(hAxes2,'YColor','k','Box','on','ygrid','on','xgrid','on');
set(hAxes2,'FontName','Helvetica','FontSize',fontSize1,'LineWidth',1)
xlabel(hAxes2,'$f$ [Hz]','Color','k','Interpreter','LaTex','FontSize',fontSize1);
ylabel(hAxes2,'Phase/$\pi$ [-]','Color','k','Interpreter','LaTex','FontSize',fontSize1)
set(hAxes2,'xlim',get(hAxes1,'xlim'),'xTick',get(hAxes1,'xTick'),...
'YAxisLocation','left','Color','w');
hold off
guidata(hObject, handles)
%
%
% --- Update the data when clicking 'OK' or 'Apply'
function Fcn_GUI_INI_FMEXP_Update_Data(hObject, eventdata, handles)
handles = guidata(hObject);
global CI
try
main = handles.MainGUI;
% Obtain handles using GUIDATA with the caller's handle 
if(ishandle(main))
    mainHandles = guidata(main);
    changeMain = mainHandles.INI_BC;
    set(changeMain, 'Enable', 'on');
    String_Listbox=get(mainHandles.listbox_Info,'string');
    ind=find(ismember(String_Listbox,'<HTML><FONT color="blue">Information 3:'));
    nLength=size(String_Listbox);
    if isempty(ind)
        indStart=nLength(1);
    else
        indStart=ind-1;
        for i=nLength(1):-1:indStart+1 
            String_Listbox(i)=[];
        end
    end
    String_Listbox{indStart+1}=['<HTML><FONT color="blue">Information 3:'];
    String_Listbox{indStart+2}=['<HTML><FONT color="blue">Flame describing functions are from experimental results:'];
    set(mainHandles.listbox_Info,'string',String_Listbox);
end
catch
end
guidata(hObject, handles);
% guidata(hObject, handles);
assignin('base','CI',CI);                   % save the current information to the workspace


% --- Executes on button press in pb_SaveFig.
function pb_SaveFig_Callback(varargin)
global CI
hObject = varargin{1};
handles = guidata(hObject);
Fig                 = figure;
set(Fig,'units','points')
posFig              = get(handles.figure,'position');
copyobj(handles.axes1, Fig);
copyobj(handles.axes2, Fig);
hAxes               = get(Fig,'children');
set(hAxes(1),       'units','points',...
                    'position',[60 60 200 150],...
                    'ActivePositionProperty','position')
set(hAxes(2),       'units','points',...
                    'position',[60 210 200 150],...
                    'ActivePositionProperty','position')
pos1                = get(hAxes(1),'position');
pos2                = get(hAxes(2),'position');
posAxesOuter = [0 0 300 400];
hChildren = get(hAxes(2), 'children');
for ss = 1:length(hChildren)
set(get(get(hChildren(ss),'Annotation'),'LegendInformation'),'IconDisplayStyle','on'); 
set(hChildren(ss),'DisplayName',['$\hat{u}_1/\bar{u}_1=$' num2str(CI.FMEXP.uRatio(end+1-ss))]);
end
axes(hAxes(2))
hl=legend('show');
set(hl,'interpreter','latex','Fontsize',handles.FontSize(2),'box','off','Unit','points')
set(hAxes(1),       'position',pos1)
set(Fig,        'units','points',...
                'position', [posFig(1)+0.5*posFig(3)-0.5*posAxesOuter(3),...
                            posFig(2)+0.5*posFig(4)-0.5*posAxesOuter(4),...
                            posAxesOuter(3:4)])   
                        
  
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
%--------------------------------------------------------------------------

% --- Executes on selection change in pop_Plot.
function pop_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to pop_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_SaveFig,'enable','off');

% --- Executes during object creation, after setting all properties.
function pop_Plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
%-- Color set
function color_type=Fcn_color_set(color_number)
cmap = colormap(hot);
n_sample=round(linspace(1,64,color_number));
for ss=1:length(n_sample)
    color_type(ss,1:3)=cmap(n_sample(ss),1:3);
end
%--------------------------------------------------------------------------
% --- Executes on selection change in listbox_EXP.
function listbox_EXP_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_EXP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_EXP contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_EXP


% --- Executes during object creation, after setting all properties.
function listbox_EXP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_EXP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_EXP_add.
function pb_EXP_add_Callback(hObject, eventdata, handles)
% hObject    handle to pb_EXP_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
CI.FMEXP.indexIMPORT = 1;
assignin('base','CI',CI);                   % save the current information to the workspace   
GUI_INI_FM_IMPORT('GUI_INI_FMEXP', handles.figure);
Fcn_GUI_INI_FMEXP_Enable(hObject,CI.FMEXP.nFTF)


% --- Executes on button press in pb_EXP_modify.
function pb_EXP_modify_Callback(hObject, eventdata, handles)
% hObject    handle to pb_EXP_modify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
CI.FMEXP.indexIMPORT = 2;
CI.FMEXP.indexModify = get(handles.listbox_EXP, 'value');
assignin('base','CI',CI);                   % save the current information to the workspace   
if isempty(CI.FMEXP.indexModify)
    errordlg('No FTF has been selected!','Error');
else
    GUI_INI_FM_IMPORT('GUI_INI_FMEXP', handles.figure);
end

% --- Executes on button press in pb_EXP_delete.
function pb_EXP_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pb_EXP_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI
indexDelete     = get(handles.listbox_EXP, 'value');
String_Listbox  = get(handles.listbox_EXP,'string');
if  isempty(indexDelete)
    errordlg('There is no FTF!','Error');
    Fcn_GUI_INI_FMEXP_Enable(hObject,CI.FMEXP.nFTF)
else
    String_Listbox(indexDelete)     = [];
    set(handles.listbox_EXP,'string',String_Listbox,'value',1);
    CI.FMEXP.FTF{indexDelete}       = [];
    CI.FMEXP.uRatio(indexDelete)    = []; 
    CI.FMEXP.nFTF                   = CI.FMEXP.nFTF - 1; 
    Fcn_GUI_INI_FMEXP_Enable(hObject,CI.FMEXP.nFTF)
end
assignin('base','CI',CI);                   % save the current information to the workspace 
