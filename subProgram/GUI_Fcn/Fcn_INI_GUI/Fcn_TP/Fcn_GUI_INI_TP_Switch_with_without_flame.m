function Fcn_GUI_INI_TP_Switch_with_without_flame(varargin)
hObject = varargin{1};
handles = guidata(hObject);
global CI
switch CI.CD.isNoFlame
    case 1
        set(handles.pop_HA_style,   'value',1,'enable','off');
        set(handles.edit_TD_Tratio, 'value',1,'enable','off');
    otherwise
        set(handles.pop_HA_style,   'enable','on');
        set(handles.edit_TD_Tratio, 'enable','on');
end
guidata(hObject, handles);  