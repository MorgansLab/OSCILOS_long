function [x_resample,p,u]=Fcn_calculation_eigenmode(s_star)
% This function is used to plot the modeshape of slected mode 
global CI
FDF         = Fcn_flame_model(s_star);
[R1,~]     = Fcn_boundary_condition(s_star); % B.B. 05/07/2019 - R2 ignored

Te = Fcn_TF_entropy_convection(s); %B.B. 12/07/2019
%--------------------------------
tau_plus    = CI.TP.tau_plus;
tau_minus   = CI.TP.tau_minus;
tau_c       = CI.TP.tau_c;
%
for ss = 1:CI.TP.numSection-1 
    D1 = diag([ exp(-s_star*tau_plus(ss)),...
                exp( s_star*tau_minus(ss)),...
                exp(-s_star*tau_c(ss))]);
    switch CI.CD.SectionIndex(ss+1)
        case 0
        case 1
            B2b     = zeros(3);
            B2b(3,2)= CI.TP.DeltaHr./CI.TP.c_mean(2,ss+1)./CI.TP.c_mean(1,ss)./CI.TP.Theta(ss).*FDF;
            Bsum    = CI.TPM.B1{2,ss}*(CI.TPM.B2{1,ss}\CI.TPM.B1{1,ss}) + B2b;
            BC1     = Bsum*CI.TPM.C1;
            BC2     = CI.TPM.B2{2,ss}*CI.TPM.C2;
            CI.TPM.BC{ss}   = BC2\BC1;
    end
end
%
A_minus(1)  = 1;
E(1)        = 0;
A_plus(1)   = R1.*A_minus(1);
Array(:,1)  = [A_plus(1),A_minus(1),E(1)]';
%
for k = 1:CI.TP.numSection-1
    Matrix_tau = diag([ exp(-tau_plus(k).*s_star)    exp(tau_minus(k).*s_star)    exp(-tau_c(k).*s_star)]);
    Array(:,k+1)    = CI.TPM.BC{k}*Matrix_tau*Array(:,k);
    A_plus(k+1)     = Array(1,k+1);
    A_minus(k+1)    = Array(2,k+1);
    E(k+1)          = Array(3,k+1);
end
%

% B.B. 05/07/2019 - START
% If the heat exchanger is being employed, the plot must extend beyond the
% OSCILOS computational area, which does not extend beyond the heat
% exchanger to the system outlet
if CI.BC.StyleOutlet == 8
    D1End = diag([ exp(-s_star*tau_plus(end)),...
                exp( s_star*tau_minus(end)),...
                Te*exp(-s_star*tau_c(end))]); % transfer matrix for section of duct immediately previous to HX
    [~,~,hx,~] = HX_End_Condition(s_star,CI); % calculate HX behaviour
    temp = hx.Thx * D1End * Array(:,end); % find wave amplitudes AFTER the HX
    A_plus(CI.TP.numSection+1) = temp(1);
    A_minus(CI.TP.numSection+1) = temp(2);
    E(CI.TP.numSection+1) = temp(3);
    
    for k=1:length(CI.CD.x_sample)-1
        x_resample(k,:)=linspace(CI.CD.x_sample(k),CI.CD.x_sample(k+1),51);    % resample of x-coordinate
    end
    %resample the wave amplitudes between the HX OUTLET and system OUTLET
    x_resample(length(CI.CD.x_sample),:) = linspace(CI.CD.x_sample(length(CI.CD.x_sample))+CI.BC.hx.hxTemp.hxLength,CI.CD.x_sample(length(CI.CD.x_sample))+CI.BC.hx.hxTemp.hxLength+CI.BC.hx.ductLength,51);
    % speed of sound and mean velocity
    c_mean      = [CI.TP.c_mean(1,:),sqrt(CI.BC.hx.hxTemp.R*CI.BC.hx.hxTemp.gamma*CI.BC.hx.hxTemp.TNm)];
    u_mean      = [CI.TP.u_mean(1,:),CI.BC.hx.hxTemp.uNm];
    rho_mean    = [CI.TP.rho_mean(1,:),CI.BC.hx.hxTemp.PNm/(CI.BC.hx.hxTemp.R*CI.BC.hx.hxTemp.TNm)];
    %     
    for k = 1:length(CI.CD.x_sample)
        kw1_plus(k) = s_star./(c_mean(k)+u_mean(k));
        kw1_minus(k) = s_star./(c_mean(k)-u_mean(k));
        p(k,:) =    A_plus(k).*exp(-kw1_plus(k).*(x_resample(k,:)-x_resample(k,1)))+...
                    A_minus(k).*exp( kw1_minus(k).*(x_resample(k,:)-x_resample(k,1)));
        u(k,:) =    (A_plus(k).*exp(-kw1_plus(k).*(x_resample(k,:)-x_resample(k,1)))-...
                    A_minus(k).*exp( kw1_minus(k).*(x_resample(k,:)-x_resample(k,1))))./rho_mean(k)./c_mean(k);
    end

else % B.B. 05/07/2019 - STOP
    for k=1:length(CI.CD.x_sample)-1
        x_resample(k,:)=linspace(CI.CD.x_sample(k),CI.CD.x_sample(k+1),100);    % resample of x-coordinate
    end
    % speed of sound and mean velocity
    c_mean      = CI.TP.c_mean(1,:);
    u_mean      = CI.TP.u_mean(1,:);
    rho_mean    = CI.TP.rho_mean(1,:);
    %     
    for k = 1:length(CI.CD.x_sample)-1
        kw1_plus(k) = s_star./(c_mean(k)+u_mean(k));
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
        Te = k;
    case 2
        Te = k.*exp((tau.*s).^2./4);
    case 3
        if tau == 0
            tau = eps;
        end % B.B. 12/07/2019 START
        Te = k.*(exp(tau*s) - exp(-tau*s))./(2*tau*s); %consistent with email discussion on 12/07/2019 
%       Te = k.*sinc(tau*s./pi);                       %between Dong, Aimee and bertie
        % B.B. 12/07/2019 STOP 
end                        
%
% ----------------------Flame transfer function ---------------------------
%
function F = Fcn_flame_model(s)
global FDF
global CI
F = polyval(FDF.num,s)./polyval(FDF.den,s).*exp(-s.*FDF.tauf);
if CI.indexFM == 0
    switch CI.FM.NL.style
        case 2
            uRatio = FDF.uRatio;
            if FDF.uRatio == 0
                uRatio = eps;
            end
        qRatioLinear = abs(F).*uRatio; 
        Lf = interp1(  CI.FM.NL.Model2.qRatioLinear,...
                       CI.FM.NL.Model2.Lf,...
                       qRatioLinear,'linear','extrap');                                    
        F = F.*Lf; 
    %     otherwise
    end
end
clear FDF
%
% -----------------------------end-----------------------------------------