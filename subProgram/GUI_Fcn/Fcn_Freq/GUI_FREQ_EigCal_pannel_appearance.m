function GUI_FREQ_EigCal_pannel_appearance(varargin)
% This program is used to determine the appearance of GUI_FREQ_EigCal
%
% we need to check if this function has ever been run
% we still need to check which UI is visible or not, enable or disable
%
%
% 1. without heat perturbation
% 2. with heat perturbations
% 2.1 with linear heat perturbations
% 2.2 with nonlinear heat perturbations
% 2.2.1 with nonlinear flame model
% 2.2.2 flame describing functions are from experiment or CFD data
% 3. with nonlinear passive dampers
hObject = varargin{1};
handles = guidata(hObject);
global CI

idExistHR = any(strcmp('HR_config',fieldnames(CI.CD)));
switch idExistHR
    case 0          
        id = 1;         % without HR
    case 1
        if isempty(CI.CD.HR_config) == 1
            id = 1;
        else
            if isempty(find(CI.CD.HR_config(:,3)==1)) == 0;
                id = 2;     % with HR and with nonlinear HR
            else
                id = 1;     % with HR and without nonlinear HR
            end
        end
end
% if isempty(CI.CD.HR_config) || isempty(find(CI.CD.HR_config(:,3)==1)) 
if id == 1
    % There is no nonlinear dampers in the system
    if isempty(CI.CD.indexHP)                       % without heat perturbation
        CI.EIG.APP_style = 11;                      % without heat addition
    else    % with heat perturbations
        CI.FM.numHP = length(CI.FM.indexFM);        % number of unsteady heat sources
        for ss = 1:CI.FM.numHP
            CI.FM.indexFMType{ss} = find(CI.FM.indexFM == ss); 
        end
        CI.FM.numHPNL = length(find(CI.FM.indexFM > 1));    % number of nonlinear unsteady heat sources
        %    
        if CI.TP.isHP_final == 0                 % mean heat addition is zero
            CI.EIG.APP_style = 12;                  % linear system
        else                                     % with mean heat addition
            if CI.FM.indexFM == 1
                CI.EIG.APP_style = 12;
            elseif CI.FM.numHPNL == 1 && ~isempty(find(CI.FM.indexFM == 2))
                CI.EIG.APP_style = 21;           % nonlinear flame model, velocity ratios can be selected
                % we need to find the location of the main unsteady heat
                % sources among these unsteady heat sources
                CI.FM.indexMainHPinHp  = find(CI.FM.indexFM == 2);
            elseif CI.FM.numHPNL == 1 && ~isempty(find(CI.FM.indexFM == 3))
                CI.EIG.APP_style = 22;           % from exp or CFD flame describing function
                % we need to find the location of the main unsteady heat
                % sources among these unsteady heat sources
                CI.FM.indexMainHPinHp  = find(CI.FM.indexFM == 3);
            elseif CI.FM.numHPNL > 1 && isempty(find(CI.FM.indexFM == 3))
                CI.EIG.APP_style = 3;            % More than one nonlinear flame, but velocity ratios can be selected
            else
                errordlg('The current version still does not support this situation!','Error');
                return 
        % further work on multi-nonlinear system
        % ...
        % ...
        % ...
            end
        end
    end

else
    % There is nonlinear HR in the system and enforce oscillations at the
    % inlet. Experimentally measured nonlinear FDF is not applicable in
    % this situation.
    if ~isempty(find(CI.FM.indexFM == 3)) % Nonlinear dampers + nonlinear experimental FDF
        errordlg('The current version still does not support this situation!','Error');
        return
    else    % Nonlinear dampers and any flame model(except experimental FDF)
        CI.EIG.APP_style = 3;
    end
    
end
assignin('base','CI',CI);
%
switch CI.IsRun.GUI_FREQ_EigCal
    case 0
        set(handles.ObjEditEnable_AOC,    'Enable','off');
        switch CI.EIG.APP_style
            case {11,12}
                set(handles.ObjEditVisible_uRatio,      'visible','off');
                set(handles.ObjEditVisible_pRatio,      'visible','off');
            case 21                             % nonlinear flame model
                set(handles.ObjEditVisible_uRatio,      'visible','on');
                set(handles.ObjEditVisible_pRatio,      'visible','off');
                
            case 22                             % nonlinear flame model
                % Begin adding by DY 17/Feb/2020
                set(handles.ObjEditVisible_uRatio,      'visible','on');
                set(handles.ObjEditVisible_pRatio,      'visible','off');
                % end adding by DY 17/Feb/2020
                HP = CI.FM.HP{CI.FM.indexMainHPinHp};
                CI.EIG.FDF.uRatioSp             = HP.FMEXP.uRatio;
                CI.EIG.FDF.uRatioNum            = length(CI.EIG.FDF.uRatioSp);
                set(handles.edit_uRatio_min,       'string',num2str(CI.EIG.FDF.uRatioSp(1)));
                set(handles.edit_uRatio_max,       'string',num2str(CI.EIG.FDF.uRatioSp(end)));
                set(handles.edit_uRatio_SampNum,   'string',num2str(CI.EIG.FDF.uRatioNum));
            case 3
                set(handles.ObjEditVisible_uRatio,      'visible','off');
                set(handles.ObjEditVisible_pRatio,      'visible','on');                
        end
    case 1 
        set(handles.ObjEditEnable_AOC,    'Enable','on');
        GUI_FREQ_EigCal_PLOT(hObject)
        switch CI.EIG.APP_style
            case {11,12}
                set(handles.ObjEditVisible_uRatio,      'visible','off');
                set(handles.ObjEditVisible_pRatio,      'visible','off');
                set(handles.pop_PlotType,...
                'string',{'Map of eigenvalues';'Modeshape'},...
                'enable','on'); 
            case {21,22}                             % nonlinear flame model
                set(handles.ObjEditVisible_uRatio,      'visible','on');
                set(handles.ObjEditVisible_pRatio,      'visible','off');
                % -----------------------------------
                set(handles.edit_uRatio,'string',num2str(CI.EIG.FDF.uRatioSp(1)));
                set(handles.edit_uRatio_min,       'string',num2str(CI.EIG.FDF.uRatioSp(1)));
                set(handles.edit_uRatio_max,       'string',num2str(CI.EIG.FDF.uRatioSp(end)));
                set(handles.edit_uRatio_SampNum,   'string',num2str(CI.EIG.FDF.uRatioNum));
                %  pannel related to uRatio 
                n = str2double(get(handles.edit_uRatio_SampNum,'string'));
                set(handles.slider_uRatio,...
                        'Enable','on',...
                        'min',1,...
                        'max',n,...
                        'value',1,...
                        'SliderStep',[1/(n-1), 1/(n-1)]);
                set(handles.edit_uRatio,'string',num2str(CI.EIG.FDF.uRatioSp(1)));
                set(handles.edit_uRatio_min,       'string',num2str(CI.EIG.FDF.uRatioSp(1)));
                set(handles.edit_uRatio_max,       'string',num2str(CI.EIG.FDF.uRatioSp(end)));
                set(handles.edit_uRatio_SampNum,   'string',num2str(CI.EIG.FDF.uRatioNum));
                set(handles.pop_PlotType,...
                'string',{'Map of eigenvalues';'Modeshape'; 'Evolution of eigenvalue with velocity ratio'},...
                'enable','on'); 
            case 3                             % nonlinear flame model
                set(handles.ObjEditVisible_uRatio,      'visible','off');
                set(handles.ObjEditVisible_pRatio,      'visible','on');
                % -----------------------------------
                set(handles.edit_pRatio,'string',num2str(CI.EIG.FDF.pRatioSp(1)));
                set(handles.edit_pRatio_min,       'string',num2str(CI.EIG.FDF.pRatioSp(1)));
                set(handles.edit_pRatio_max,       'string',num2str(CI.EIG.FDF.pRatioSp(end)));
                set(handles.edit_pRatio_SampNum,   'string',num2str(CI.EIG.FDF.pRatioNum));
                %  pannel related to pRatio 
                n = str2double(get(handles.edit_pRatio_SampNum,'string'));
                set(handles.slider_pRatio,...
                        'Enable','on',...
                        'min',1,...
                        'max',n,...
                        'value',1,...
                        'SliderStep',[1/(n-1), 1/(n-1)]);
                set(handles.edit_pRatio,'string',num2str(CI.EIG.FDF.pRatioSp(1)));
                set(handles.edit_pRatio_min,       'string',num2str(CI.EIG.FDF.pRatioSp(1)));
                set(handles.edit_pRatio_max,       'string',num2str(CI.EIG.FDF.pRatioSp(end)));
                set(handles.edit_pRatio_SampNum,   'string',num2str(CI.EIG.FDF.pRatioNum));
                set(handles.pop_PlotType,...
                'string',{'Map of eigenvalues';'Modeshape'; 'Evolution of eigenvalue with velocity ratio'},...
                'enable','on'); 
                % -----------------------------------
        end
        set(handles.pop_numMode,    'enable','on');  
        set(handles.pb_AOC_Plot,    'enable','on');
        eigenvalue = CI.EIG.Scan.EigValCol{1};
        for k = 1:length(eigenvalue)
           StringMode{k} = ['Mode number: ' num2str(k)]; 
        end
        set(handles.pop_numMode,    'string',StringMode)
        %
        if isempty(eigenvalue)
             errordlg('The searching frequency and growth rate range is not enough large, please increase them','Error');
        else
            data_num(:,1)=abs(imag(eigenvalue)./2./pi);
            data_num(:,2)=real(eigenvalue);
            data_cell=num2cell(data_num);
            set(handles.uitable,'data',data_cell);         % Update the table
        end
        guidata(hObject, handles);
end
switch CI.EIG.APP_style
    case 22                             % from exp or CFD flame describing function
        set(handles.edit_uRatio_min,       'enable','off');
        set(handles.edit_uRatio_max,       'enable','off');
        set(handles.edit_uRatio_SampNum,   'enable','off');
        set(handles.edit_pRatio_min,       'enable','off');
        set(handles.edit_pRatio_max,       'enable','off');
        set(handles.edit_pRatio_SampNum,   'enable','off');        
end

% in case there are two heat addition, but the first one is a
% steady one and the second one is unsteady  ?
% the number of HP is always not larger than that of HA
% it is necessary to locate the order of HP in HA
%
if ~isempty(CI.CD.indexHA) && ~isempty(CI.CD.indexHP)
   for ss = 1:length(CI.CD.indexHP)
       CI.FM.indexHPinHA(ss) = find(CI.CD.indexHA == CI.CD.indexHP(ss));
   end
end

%
% check the scan domain information
switch CI.IsRun.GUI_FREQ_EigCal_AD 
    case 0
        CI.EIG.Scan.FreqMin = 0;
        CI.EIG.Scan.FreqMax = 1000;
        CI.EIG.Scan.FreqNum = 10;
        CI.EIG.Scan.GRMin   = -200;
        CI.EIG.Scan.GRMax   = 200;
        CI.EIG.Scan.GRNum   = 10;
    case 1
end
guidata(hObject, handles);
%
assignin('base','CI',CI);


