function [x_resample,p,u]=Fcn_calculation_eigenmode(s_star)
% This function is used to plot the modeshape of slected mode 


global CI

[R1,R2]     = Fcn_boundary_condition(s_star);
%--------------------------------
tau_plus    = CI.TP.tau_plus;
tau_minus   = CI.TP.tau_minus;
tau_c       = CI.TP.tau_c;
%
HR_Flag=1;
Liner_Flag=1;
% Define waves at the inlet
if CI.CD.system_type==0  % Linear acoustic system
    Index_flame=find(CI.CD.index == 1);
    if isempty(Index_flame) == 0
       u_osc_flame= CI.EIG.FDF.uRatioSp(CI.EIG.uR.indexShow)*CI.TP.u_mean(1,Index_flame-1);  
       [Array]    = inlet_waves_calculation_from_nonlinear_flame(u_osc_flame,R1,Index_flame,s_star);
       A_minus(1)  = Array(2,1);
       A_plus(1)   = Array(1,1);
       E(1)        = Array(3,1);
    else
        A_minus(1)  = 1;
        E(1)        = 0;
        A_plus(1)   = R1.*A_minus(1);
        Array(:,1)  = [A_plus(1); A_minus(1); E(1)];
    end

else             % Nonlinear acoustic system
   A_minus(1)  = CI.EIG.PR.A1minusSp(CI.EIG.PR.indexShow);
   if abs(A_minus(1)) < 0.001
      A_minus(1) = 0.001;
   end
   A_plus(1)         = R1.*A_minus(1);
   E(1)              = 0;  
   Array(:,1)  = [A_plus(1); A_minus(1); E(1)];
end

for ss = 1:CI.TP.numSection-1 
    %% Transfer matrixes across sectional interface
    switch CI.CD.index(ss+1)
        case 0
        case 1
            i_omega        =s_star; 
            w_0            =[A_plus(ss); A_minus(ss); E(ss)]; % These values are useless in the linear HR model, but need to be defined for the HR function
            Matrix_tau     =diag([ exp(-tau_plus(ss).*i_omega)    exp(tau_minus(ss).*i_omega)    exp(-tau_c(ss).*i_omega)]);
            Array_LeftInt  =Matrix_tau*w_0;
            uRatio  = abs((Array_LeftInt(1) - Array_LeftInt(2)))./CI.TP.c_mean(1,ss)./CI.TP.rho_mean(1,ss)./CI.TP.u_mean(1,ss);
            FDF     = Fcn_flame_model_nonlinear_HR(s_star,uRatio);
            B2b     = zeros(3);
            B2b(3,2)= CI.TP.DeltaHr./CI.TP.c_mean(2,ss+1)./CI.TP.c_mean(1,ss)./CI.TP.Theta(ss).*FDF;
            Bsum    = CI.TPM.B1{2,ss}*(CI.TPM.B2{1,ss}\CI.TPM.B1{1,ss}) + B2b;
            BC1     = Bsum*CI.TPM.C1;
            BC2     = CI.TPM.B2{2,ss}*CI.TPM.C2;
            CI.TPM.BC{ss}   = BC2\BC1;
        case 2
            HR_Num         =HR_Flag;
            i_omega        =s_star;                               
            w_0            =[A_plus(ss); A_minus(ss); E(ss)]; % These values are useless in the linear HR model, but need to be defined for the HR function
            Matrix_tau     =diag([ exp(-tau_plus(ss).*i_omega)    exp(tau_minus(ss).*i_omega)    exp(-tau_c(ss).*i_omega)]);
            Array_LeftInt  =Matrix_tau*w_0;
            Mtr_HR_33=Fcn_calculation_Oscillations_across_HR(ss,HR_Num,i_omega, Array_LeftInt(1),Array_LeftInt(2));
            CI.TPM.BC{ss}  =Mtr_HR_33; 
            HR_Flag  =HR_Flag+1;
        case 30
            % Refer to the transfer matrix calculated by an outer liner
            % wave calculation function
            CI.TPM.BC{ss}  =diag([1,...
                                  1,...
                                  1]);
        case 31
            Liner_Num      =Liner_Flag;
            i_omega        =s_star;                           % s is used here directory as the real part of it is assumed to be small and thus will not affect the liner performance much.
            Mtr_Liner_33   = Fcn_calculation_Oscillations_across_Liner(ss,Liner_Num,i_omega);
            CI.TPM.BC{ss}  =Mtr_Liner_33;
            Liner_Flag     =Liner_Flag+1;
    end
    
    %% Waves at the start of each section
    if CI.CD.index(ss)==30                                            % Calculate waves immediately after the liner
        D_Liner         =diag([ 1    1    exp(-tau_c(ss).*s_star)]);  % It is assumed that only acoustic waves are considered in the liner damping model. Entropy wave convects from left side to the right side.
        Array(:,ss+1)    = CI.TPM.BC{ss}*D_Liner*Array(:,ss);
    else
        Matrix_tau      = diag([ exp(-tau_plus(ss).*s_star)    exp(tau_minus(ss).*s_star)    exp(-tau_c(ss).*s_star)]);
        Array(:,ss+1)    = CI.TPM.BC{ss}*Matrix_tau*Array(:,ss);
    end
    A_plus(ss+1)     = Array(1,ss+1);
    A_minus(ss+1)    = Array(2,ss+1);
    E(ss+1)          = Array(3,ss+1);
        
end
%
for k=1:length(CI.CD.x_sample)-1
    x_resample(k,:)=linspace(CI.CD.x_sample(k),CI.CD.x_sample(k+1),51);    % resample of x-coordinate
end
% speed of sound and mean velocity
c_mean      = CI.TP.c_mean(1,:);
u_mean      = CI.TP.u_mean(1,:);
rho_mean    = CI.TP.rho_mean(1,:);
%     
for k = 1:length(CI.CD.x_sample)-1
    Liner_Flag=1;
    if CI.CD.index(k)==30
        Liner_Num    =Liner_Flag;
        [Osc_trans_Mtr_across_Liner] = Fcn_calculation_Osc_trans_matrixes_across_Liner(k,Liner_Num,s_star);
        A_plus_k(1)  =A_plus(k);
        A_minus_k(1) =A_minus(k);
        E_k(1)       =0;
        for step_k=2:1:51
            wave_k=Osc_trans_Mtr_across_Liner(step_k-1).mat*[A_plus_k(1);A_minus_k(1);E_k(1)];
            A_plus_k(step_k)   =wave_k(1);
            A_minus_k(step_k)  =wave_k(2);
        end   
        p(k,:)      =A_plus_k+A_minus_k;
        u(k,:)      =(A_plus_k-A_minus_k)./rho_mean(k)./c_mean(k);
        Liner_Flag  =Liner_Flag+1;
    else
    kw1_plus(k)  = s_star./(c_mean(k)+u_mean(k));
    kw1_minus(k) = s_star./(c_mean(k)-u_mean(k));
    p(k,:) =    A_plus(k).*exp(-kw1_plus(k).*(x_resample(k,:)-x_resample(k,1)))+...
                A_minus(k).*exp( kw1_minus(k).*(x_resample(k,:)-x_resample(k,1)));
    u(k,:) =    (A_plus(k).*exp(-kw1_plus(k).*(x_resample(k,:)-x_resample(k,1)))-...
                A_minus(k).*exp( kw1_minus(k).*(x_resample(k,:)-x_resample(k,1))))./rho_mean(k)./c_mean(k);
    end
end

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
% -----------Inlet_waves_calculation_from_nonlinear_flame------------------
function [Array]    = inlet_waves_calculation_from_nonlinear_flame(u_osc_flame,R1,Index_flame,s_star)
global CI
tau_plus    = CI.TP.tau_plus;
tau_minus   = CI.TP.tau_minus;
tau_c       = CI.TP.tau_c;
HR_Flag=1;
Liner_Flag=1;
G = eye(3);
for ss = 1:(Index_flame-1) 
D1      = diag([ exp(-tau_plus(ss).*s_star)    exp(tau_minus(ss).*s_star)    exp(-tau_c(ss).*s_star)]);
    %% Transfer matrixes across sectional interface
    switch CI.CD.index(ss+1)
        case 0
            Z       = CI.TPM.BC{ss}*D1;
        case 1
            Z       =D1;
            % This calculation stops immediately before the flame
        case 2
            HR_Num   =HR_Flag;
            i_omega  =s_star;                               
            w_1      =[1; 1; 0];       % These values are useless in the linear HR model, but need to be defined for the HR function
            A_1_p    =w_1(1);
            A_1_n    =w_1(2);
            Mtr_HR_33=Fcn_calculation_Oscillations_across_HR(ss,HR_Num,i_omega, A_1_p,A_1_n);
            Z        =Mtr_HR_33*D1; 
            HR_Flag  =HR_Flag+1;
        case 30
            % Refer to the transfer matrix calculated by an outer liner
            % wave calculation function
            Z        =D1;
        case 31
            Liner_Num      =Liner_Flag;
            i_omega        =s_star;                           % s is used here directory as the real part of it is assumed to be small and thus will not affect the liner performance much.
            Mtr_Liner_33   = Fcn_calculation_Oscillations_across_Liner(ss,Liner_Num,i_omega);
            D_Liner      =diag([ 1,...
                                 1,...
                                 exp(-s_star*tau_c(ss))]);
            Z              =Mtr_Liner_33*D_Liner;
            Liner_Flag     =Liner_Flag+1;
    end 

    G               = Z*G;
end
A_minus(1)=abs(CI.TP.rho_mean(2,Index_flame-1)*CI.TP.c_mean(2,Index_flame-1)*u_osc_flame/(G(1,1)*R1+G(1,2)-G(2,1)*R1-G(2,2)));
if A_minus(1)<0.001
    A_minus(1)=0.001;
end
A_plus(1)=R1*A_minus(1);
E(1)=0;
Array(:,1)  = [A_plus(1); A_minus(1); E(1)];

% -----------------------------end-----------------------------------------
