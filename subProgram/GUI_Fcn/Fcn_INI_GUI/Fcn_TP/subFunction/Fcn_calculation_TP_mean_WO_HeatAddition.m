function [p_mean2,rho_mean2,u_mean2] =...
    Fcn_calculation_TP_mean_WO_HeatAddition(p_mean1,rho_mean1,u_mean1,Theta,gamma)
% This function is used to calculate the mean thermoproperties changing
% across the interface between two sections with different section surface
% area. 
% The heat addition is not accounted for in this program
% Theta=S2/S1;
% gamma is considered constant before and after the flame separately.
% global MF
%
% last updated on 08/11/2016
%
% reference values
MF.p1       = p_mean1;
MF.rho1     = rho_mean1;
MF.u1       = u_mean1;
MF.Theta    = Theta;
MF.gamma    = gamma;
%
[p_mean2, rho_mean2, u_mean2] = FcnSolve(@myfun_p_rho_u, MF);
%
function [p_mean2, rho_mean2, u_mean2] = FcnSolve(myfun, MF)
%
options = optimset('Display','off');        % the calculation results by fsolve will not be shown in the workspace
x0      = [1,1,1];  
F       = @(x)myfun(x, MF);
x2      = fsolve(F, x0, options);   % solve equation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this part has been changed on 08/11/2016
iternum     = 0;
exitflag    = 0;
while exitflag > 4 || exitflag < 1 && iternum <20
    [x2, ~, exitflag]   = fsolve(F, x0, options);   % solve equation
    iternum = iternum + 1;
    x0      = x2;
end
if iternum>19
    h = msgbox('The mean flow calculation is not converged!'); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p_mean2     = x2(1)*MF.p1;               
rho_mean2   = x2(2)*MF.rho1;
u_mean2     = x2(3)*MF.u1;
%
function F = myfun_p_rho_u(x, MF)
% p2   = x(1);
% rho2 = x(2);
% u2   = x(3);
%
p1      = MF.p1;
rho1    = MF.rho1;
u1      = MF.u1;
Theta   = MF.Theta;
gamma   = MF.gamma;
%
p2      = x(1)*p1;
rho2    = x(2)*rho1;
u2      = x(3)*u1;
F(1) = Theta*rho2*u2 - rho1*u1;
%
F(3) = gamma/(gamma-1)*(p2/rho2 - p1/rho1) + 0.5*(u2^2 - u1^2);
%
if Theta>=1              % Area increasing
    F(2) = p2+rho2*u2^2 - (p1 + rho1*u1^2/Theta);
elseif Theta<1          % Area decreasing
    F(2) = p2*rho1^gamma - p1*rho2^gamma;
end
%
%----------------------------------end-------------------------------------
