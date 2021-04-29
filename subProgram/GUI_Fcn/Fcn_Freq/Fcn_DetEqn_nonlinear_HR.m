function F = Fcn_DetEqn_nonlinear_HR(s)
global CI
global PR
[R1,R2]     = Fcn_boundary_condition(s);
Rs          = -0.5*CI.TP.M_mean(end)./(1 + 0.5*(CI.TP.gamma(end) - 1 ).*CI.TP.M_mean(end));
%
Te = Fcn_TF_entropy_convection(s);
%--------------------------------
tau_plus    = CI.TP.tau_plus;
tau_minus   = CI.TP.tau_minus;
tau_c       = CI.TP.tau_c;
%--------------------------------
% Flags of HR and Liner
HR_Flag     = 1;
Liner_Flag  = 1;
% Initial wave amplitudes
%
A1_minus        = PR.A1minus;
if abs(A1_minus) < 1
    A1_minus = 1;
end
A1_plus         = R1.*A1_minus;
E1              = 0;
Array_RightInt  = [A1_plus, A1_minus, E1]';     % Waves after the interface, when CI.CD.index = 1, it indicates the left boundary
% 
G = eye(3);
for ss = 1:CI.TP.numSection-1 
    D1 = diag([ exp(-s*tau_plus(ss)),...
                exp( s*tau_minus(ss)),...
                exp(-s*tau_c(ss))]);
    Array_LeftInt = D1*Array_RightInt;
    switch CI.CD.index(ss+1)
        case 0
            Z       = CI.TPM.BC{ss}*D1;
        case 1
            uRatio  = abs((Array_LeftInt(1) - Array_LeftInt(2)))./CI.TP.c_mean(1,ss)./CI.TP.rho_mean(1,ss)./CI.TP.u_mean(1,ss);
            FDF     = Fcn_flame_model_nonlinear_HR(s,uRatio);
            B2b     = zeros(3);
            B2b(3,2)= CI.TP.DeltaHr./CI.TP.c_mean(2,ss+1)./CI.TP.c_mean(1,ss)./CI.TP.Theta(ss).*FDF;
            Bsum    = CI.TPM.B1{2,ss}*(CI.TPM.B2{1,ss}\CI.TPM.B1{1,ss}) + B2b;
            BC1     = Bsum*CI.TPM.C1;
            BC2     = CI.TPM.B2{2,ss}*CI.TPM.C2;
            Z       = (BC2\BC1)*D1;
        case 2
            Mtr_HR_33=Fcn_calculation_Oscillations_across_HR(ss,HR_Flag,s, Array_LeftInt(1),Array_LeftInt(2));
            E        =[1,0,0;0,1,0;0,0,0];
            Z        =E*Mtr_HR_33*D1; 
            HR_Flag  =HR_Flag+1;
        case 30
            Z=eye(3)*D1;
            
        case 31
            Liner_Num    =Liner_Flag;
            i_omega      =s;                           % s is used here directory as the real part of it is assumed to be small and thus will not affect the liner performance much.
            Mtr_Liner_33 = Fcn_calculation_Oscillations_across_Liner(ss,Liner_Num,i_omega);
            D_Liner      =diag([ 1,...
                                 1,...
                                 exp(-s*tau_c(ss))]);  % It is assumed that only acoustic waves are considered in the liner damping model. Entropy wave convects from left side to the right side.
            Z            =Mtr_Liner_33*D_Liner;
            Liner_Flag   =Liner_Flag+1;
            % End adding by Dong Yang  
    end
    G = Z*G;
    Array_RightInt = Z*Array_RightInt;
end
%
%
D1End           = diag([    exp(-s*tau_plus(end)),...
                            exp( s*tau_minus(end)),...
                            Te.*exp(-s*tau_c(end))]);
%
Array_RightBD   = D1End*Array_RightInt;
AN_plus         = Array_RightBD(1);
AN_minus        = Array_RightBD(2);
EN_plus         = Array_RightBD(3);

F = (R2.*AN_plus + Rs.*EN_plus) - AN_minus;  

%
%----------------------Pressure Reflection coefficients -------------------
%
function [R1,R2] = Fcn_boundary_condition(s)
global CI
R1      = polyval(CI.BC.num1,s)./polyval(CI.BC.den1,s).*exp(-CI.BC.tau_d1.*s);
R2      = polyval(CI.BC.num2,s)./polyval(CI.BC.den2,s).*exp(-CI.BC.tau_d2.*s);
%
%----------------------Entropy convection transfer function ---------------
%
function Te = Fcn_TF_entropy_convection(s)
global CI
tau     = CI.BC.ET.Dispersion.Delta_tauCs;
k       = CI.BC.ET.Dissipation.k;
switch CI.BC.ET.pop_type_model
    case 1
        Te = 0;
    case 2
        Te = k.*exp((tau.*s).^2./4);
    case 3
        if tau == 0
            tau = eps;
        end
        Te = k.*(exp(tau*s) - exp(-tau*s))./(2*tau);
end                        
%
% ----------------------Flame transfer function ---------------------------
%
function F = Fcn_flame_model_nonlinear_HR(s,uRatio)
global CI
F = polyval(CI.FM.FTF.num,s)./polyval(CI.FM.FTF.den,s).*exp(-s.*CI.FM.FTF.tauf);
switch CI.FM.NL.style
    case 1 
    case 2
        if uRatio > 1                                
            uRatio = 1;
        end
        qRatioLinear = abs(F).*uRatio; 
        Lf = interp1(  CI.FM.NL.Model2.qRatioLinear,...
                       CI.FM.NL.Model2.Lf,...
                       qRatioLinear,'linear','extrap');                                    
        F = F.*Lf; 
    case 3
        if uRatio > 1                                
            uRatio = 1;
        end
        Lf              = interp1(  CI.FM.NL.Model3.uRatio,...
                                    CI.FM.NL.Model3.Lf,...
                                    uRatio,'linear','extrap');
        taufNSp         = CI.FM.NL.Model3.taufN.*(1-Lf);
        F = F.*Lf.*exp(-s.*taufNSp);
end
%
% -----------------------------end-----------------------------------------