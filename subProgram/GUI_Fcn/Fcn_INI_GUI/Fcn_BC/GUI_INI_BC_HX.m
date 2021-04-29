function varargout = GUI_INI_BC_HX(varargin)
% GUI_INI_BC_HX MATLAB code for GUI_INI_BC_HX.fig
%      GUI_INI_BC_HX, by itself, creates a new GUI_INI_BC_HX or raises the existing
%      singleton*.
%
%      H = GUI_INI_BC_HX returns the handle to a new GUI_INI_BC_HX or the handle to
%      the existing singleton*.
%
%      GUI_INI_BC_HX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INI_BC_HX.M with the given input arguments.
%
%      GUI_INI_BC_HX('Property','Value',...) creates a new GUI_INI_BC_HX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_INI_BC_HX_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_INI_BC_HX_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_INI_BC_HX

% Last Modified by GUIDE v2.5 01-Jun-2019 12:17:06

% Begin initialization code - DO NOT EDIT
%Variable containing all problem information.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_INI_BC_HX_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_INI_BC_HX_OutputFcn, ...
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


% --- Executes just before GUI_INI_BC_HX is made visible.
function GUI_INI_BC_HX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_INI_BC_HX (see VARARGIN)
global CI

%Open with saved or default heat exchanger properties
handles.tubeDiamEditText.String = num2str(CI.BC.hx.tubeDiameter*1000);
handles.XpEditText.String = num2str(CI.BC.hx.Xp);
handles.XlEditText.String = num2str(CI.BC.hx.Xl);
handles.nRowsEditText.String = num2str(CI.BC.hx.nRows);
handles.meanHeatTransferEditText.String = num2str(CI.BC.hx.qm);
if numel(CI.BC.hx.htfNumerator) == 1
    handles.htfNumeratorEditText.String = ['[',mat2str(CI.BC.hx.htfNumerator),']'];
else
    handles.htfNumeratorEditText.String = mat2str(CI.BC.hx.htfNumerator);
end
if numel(CI.BC.hx.htfDenominator) == 1
    handles.htfDenominatorEditText.String = ['[',mat2str(CI.BC.hx.htfDenominator),']'];
else 
    handles.htfDenominatorEditText.String = mat2str(CI.BC.hx.htfDenominator);
end
handles.ductLengthEditText.String = num2str(CI.BC.hx.ductLength*1000);
handles.endConditionPopup.Value = CI.BC.hx.endCondition; % 1 - choked, 2 - open, 3 - closed
handles.rowLossCoeffEditText.String = num2str(CI.BC.hx.lossCoeff);

%Load mean flow properties
handles.inletTemperatureText.String = num2str(CI.TP.T_mean(1,end));
handles.inletVelocityText.String = num2str(CI.TP.u_mean(1,end));
handles.inletPressureText.String = num2str(CI.TP.p_mean(1,end));

% Choose default command line output for GUI_INI_BC_HX
handles.output = hObject;

handles.mainFig = varargin{1};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_INI_BC_HX wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_INI_BC_HX_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function tubeDiamEditText_Callback(hObject, eventdata, handles)
% hObject    handle to tubeDiamEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '3';
    guidata(hObject,handles);
    return
end
if str2num(hObject.String) <= 0
    warndlg('Must be > 0')
    hObject.String = '3';
    guidata(hObject,handles);
    return
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid

% --- Executes during object creation, after setting all properties.
function tubeDiamEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tubeDiamEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XpEditText_Callback(hObject, eventdata, handles)
% hObject    handle to XpEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XpEditText as text
%        str2double(get(hObject,'String')) returns contents of XpEditText as a double
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '1.7';
    guidata(hObject,handles);
end
if str2num(hObject.String) <= 1
    warndlg('Must be > 1')
    hObject.String = '1.7';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid

% --- Executes during object creation, after setting all properties.
function XpEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XpEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XlEditText_Callback(hObject, eventdata, handles)
% hObject    handle to XlEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XlEditText as text
%        str2double(get(hObject,'String')) returns contents of XlEditText as a double
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '1.3';
    guidata(hObject,handles);
end
if str2num(hObject.String) <= 1
    warndlg('Must be > 1')
    hObject.String = '1.3';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid


% --- Executes during object creation, after setting all properties.
function XlEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XlEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function nRowsEditText_Callback(hObject, eventdata, handles)
% hObject    handle to nRowsEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nRowsEditText as text
%        str2double(get(hObject,'String')) returns contents of nRowsEditText as a double
hObject.String = num2str(floor(str2num(hObject.String)));
guidata(hObject,handles);
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '2';
    guidata(hObject,handles);
end
if str2num(hObject.String) <= 0
    warndlg('Must be > 0')
    hObject.String = '2';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid

% --- Executes during object creation, after setting all properties.
function nRowsEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nRowsEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanHeatTransferEditText_Callback(hObject, eventdata, handles)
% hObject    handle to meanHeatTransferEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanHeatTransferEditText as text
%        str2double(get(hObject,'String')) returns contents of meanHeatTransferEditText as a double
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '100000';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid


% --- Executes during object creation, after setting all properties.
function meanHeatTransferEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanHeatTransferEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in endConditionPopup.
function endConditionPopup_Callback(hObject, eventdata, handles)
% hObject    handle to endConditionPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns endConditionPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from endConditionPopup
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid
if handles.endConditionPopup.Value == 1
    CI.BC.hx.endCondition = 1;
    % Construct a questdlg with three options
    choice = questdlg('Include indirect noise from entropy waves?', ...
        'Indirect noise','Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            GUI_INI_BC_Entropy_HX('GUI_INI_BC', handles.mainFig);
        case 'No'
            CI.BC.hx.ET.pop_type_model             = 1;
            CI.BC.hx.ET.Dispersion.Delta_tauCs     = 0;
            CI.BC.hx.ET.Dissipation.k              = 0; 
    end
elseif handles.endConditionPopup.Value == 2
    CI.BC.hx.endCondition = 2;
    CI.BC.hx.ET.pop_type_model             = 1;
    CI.BC.hx.ET.Dispersion.Delta_tauCs     = 0;
    CI.BC.hx.ET.Dissipation.k              = 0; 
elseif handles.endConditionPopup.Value == 3
    CI.BC.hx.endCondition = 3;
    CI.BC.hx.ET.pop_type_model             = 1;
    CI.BC.hx.ET.Dispersion.Delta_tauCs     = 0;
    CI.BC.hx.ET.Dissipation.k              = 0; 
end
assignin('base','CI',CI);                   % save the current information to the workspace

% --- Executes during object creation, after setting all properties.
function endConditionPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endConditionPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ductLengthEditText_Callback(hObject, eventdata, handles)
% hObject    handle to ductLengthEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ductLengthEditText as text
%        str2double(get(hObject,'String')) returns contents of ductLengthEditText as a double
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '200';
    guidata(hObject,handles);
end
if str2num(hObject.String) < 0
    warndlg('Must be >= 0')
    hObject.String = '200';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid

% --- Executes during object creation, after setting all properties.
function ductLengthEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ductLengthEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function htfNumeratorEditText_Callback(hObject, eventdata, handles)
% hObject    handle to htfNumeratorEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of htfNumeratorEditText as text
%        str2double(get(hObject,'String')) returns contents of htfNumeratorEditText as a double
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '[1,0.1]';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid
charArray = char(hObject.String);
if charArray(1) ~= '['
    charArray = ['[',charArray];
end
if charArray(end) ~= ']'
    charArray = [charArray,']'];
end
hObject.String = convertCharsToStrings(charArray);

% --- Executes during object creation, after setting all properties.
function htfNumeratorEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to htfNumeratorEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function htfDenominatorEditText_Callback(hObject, eventdata, handles)
% hObject    handle to htfDenominatorEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of htfDenominatorEditText as text
%        str2double(get(hObject,'String')) returns contents of htfDenominatorEditText as a double
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '[1,0.1]';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid
charArray = char(hObject.String);
if charArray(1) ~= '['
    charArray = ['[',charArray];
end
if charArray(end) ~= ']'
    charArray = [charArray,']'];
end
hObject.String = convertCharsToStrings(charArray);

% --- Executes during object creation, after setting all properties.
function htfDenominatorEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to htfDenominatorEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in visualiseButton.
function visualiseButton_Callback(hObject, eventdata, handles)
% hObject    handle to visualiseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Xp = str2num(handles.XpEditText.String);
Xl = str2num(handles.XlEditText.String);
nRows = str2num(handles.nRowsEditText.String);
cla(handles.hxVisualiseAxes)

cplot = @(ax,r,x0,y0) plot(ax,x0 + r*cos(linspace(0,2*pi)),y0 + r*sin(linspace(0,2*pi)),'-','linewidth',2);
hold on
i = 1;
while i <= nRows;
    if mod(i,2) == 1
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,0);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,5.6*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-5.6*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,11.2*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-11.2*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,16.8*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-16.8*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,22.4*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-22.4*Xp);
    else
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,2.8*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-2.8*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,8.4*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-8.4*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,14*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-14*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,19.6*Xp);
        cplot(handles.hxVisualiseAxes,2.8,(i-1)*Xl*5.6,-19.6*Xp);
    end
    i = i + 1;
end



% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
global CI
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CI.BC.hx.tubeDiameter = str2num(handles.tubeDiamEditText.String)*0.001;
CI.BC.hx.Xp = str2num(handles.XpEditText.String);
CI.BC.hx.Xl = str2num(handles.XlEditText.String);
CI.BC.hx.nRows = str2num(handles.nRowsEditText.String);
CI.BC.hx.qm = str2num(handles.meanHeatTransferEditText.String);
CI.BC.hx.htfNumerator = str2num(handles.htfNumeratorEditText.String);
CI.BC.hx.htfDenominator = str2num(handles.htfDenominatorEditText.String);
CI.BC.hx.ductLength = str2num(handles.ductLengthEditText.String)*0.001;
CI.BC.hx.endCondition = handles.endConditionPopup.Value; % 1 - choked, 2 - open, 3 - closed
CI.BC.hx.isSetup = true;
CI.BC.hx.lossCoeff = str2num(handles.rowLossCoeffEditText.String);
assignin('base','CI',CI); 
close


% --- Executes on button press in meanPropertiesButton.
function meanPropertiesButton_Callback(hObject, eventdata, handles)
% hObject    handle to meanPropertiesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CI

%Update heat exchanger properties from the text box
CI.BC.hx.tubeDiameter = str2num(handles.tubeDiamEditText.String)*0.001;
CI.BC.hx.Xp = str2num(handles.XpEditText.String);
CI.BC.hx.Xl = str2num(handles.XlEditText.String);
CI.BC.hx.nRows = str2num(handles.nRowsEditText.String);
CI.BC.hx.qm = str2num(handles.meanHeatTransferEditText.String);
CI.BC.hx.htfNumerator = str2num(handles.htfNumeratorEditText.String);
CI.BC.hx.htfDenominator = str2num(handles.htfDenominatorEditText.String);
CI.BC.hx.ductLength = str2num(handles.ductLengthEditText.String)*0.001;
CI.BC.hx.endCondition = handles.endConditionPopup.Value; % 1 - choked, 2 - open, 3 - closed
CI.BC.hx.lossCoeff = str2num(handles.rowLossCoeffEditText.String);

% calculate mean flow properties
[~,~,CI.BC.hx.hxTemp] = HX_End_Condition(0,CI);
CI.BC.hx.meanFlowCalc = true;

%Check for any errors in the heat exchanger calculations
if CI.BC.hx.hxTemp.err == true
warndlg(['An error occured in calculating the heat exchanger behavior. ',...
        'This may be because the iterative mean flow solver failed. Is the Mach number',...
        ' sensible? Is the heat transfer sensible?'],'PANIC!','replace');
end

handles.outletTemperatureText.String = num2str(CI.BC.hx.hxTemp.TNm);
handles.outletVelocityText.String = num2str(CI.BC.hx.hxTemp.uNm);
handles.outletPressureText.String = num2str(CI.BC.hx.hxTemp.PNm);
guidata(handles.inletTemperatureText,handles);
guidata(handles.inletVelocityText,handles);
guidata(handles.inletPressureText,handles);
assignin('base','CI',CI);                   % save the current information to the workspace


function inletVelocityText_Callback(hObject, eventdata, handles)
% hObject    handle to inletVelocityText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inletVelocityText as text
%        str2double(get(hObject,'String')) returns contents of inletVelocityText as a double


% --- Executes during object creation, after setting all properties.
function inletVelocityText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inletVelocityText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inletTemperatureText_Callback(hObject, eventdata, handles)
% hObject    handle to inletTemperatureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inletTemperatureText as text
%        str2double(get(hObject,'String')) returns contents of inletTemperatureText as a double


% --- Executes during object creation, after setting all properties.
function inletTemperatureText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inletTemperatureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inletPressureText_Callback(hObject, eventdata, handles)
% hObject    handle to inletPressureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inletPressureText as text
%        str2double(get(hObject,'String')) returns contents of inletPressureText as a double


% --- Executes during object creation, after setting all properties.
function inletPressureText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inletPressureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outletVelocityText_Callback(hObject, eventdata, handles)
% hObject    handle to outletVelocityText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outletVelocityText as text
%        str2double(get(hObject,'String')) returns contents of outletVelocityText as a double


% --- Executes during object creation, after setting all properties.
function outletVelocityText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outletVelocityText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outletTemperatureText_Callback(hObject, eventdata, handles)
% hObject    handle to outletTemperatureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outletTemperatureText as text
%        str2double(get(hObject,'String')) returns contents of outletTemperatureText as a double


% --- Executes during object creation, after setting all properties.
function outletTemperatureText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outletTemperatureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outletPressureText_Callback(hObject, eventdata, handles)
% hObject    handle to outletPressureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outletPressureText as text
%        str2double(get(hObject,'String')) returns contents of outletPressureText as a double


% --- Executes during object creation, after setting all properties.
function outletPressureText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outletPressureText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rowLossCoeffEditText_Callback(hObject, eventdata, handles)
% hObject    handle to rowLossCoeffEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rowLossCoeffEditText as text
%        str2double(get(hObject,'String')) returns contents of rowLossCoeffEditText as a double
if isempty(str2num(hObject.String))
    warndlg('This input must be numerical!')
    hObject.String = '0.4';
    guidata(hObject,handles);
end
if str2num(hObject.String) < 0
    warndlg('Must be >= 0')
    hObject.String = '0.4';
    guidata(hObject,handles);
end
global CI
CI.BC.hx.meanFlowCalc = false; % h.x. properties changed - mean flow calc now invalid

% --- Executes during object creation, after setting all properties.
function rowLossCoeffEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rowLossCoeffEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
