function Fcn_GUI_INI_CD_check_flame_existence
% verify the existence of flame 
global CI
CI.CD.isNoFlame = isempty(find(CI.CD.index == 1));
assignin('base','CI',CI);                   % save the current information to the workspace
% ------------------------- end -------------------------------------------
