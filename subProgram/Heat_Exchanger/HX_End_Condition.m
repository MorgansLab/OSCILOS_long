function [R2,Rs,hx,endTransfer] = HX_End_Condition(s,CI)
%This function accepts the OSCILOS data structure (CI) and the acoustic
%complex frequency, s, and returns the acoustic and entropic reflection
%coefficients (R2, Rs)

%Test that the mean flow conditions have been calculated.
if (~isfield(CI,'TP')) || (~isfield(CI.TP,'p_mean')) || (CI.TP.p_mean(1,end) == 0)
    warndlg('Mean flow information must be calculated before the heat exchanger response can be estimated.');
    return
end

%Check if heat exchanger has been initialised + heat exchanger mean flow 
%conditions have been calculated, if not, initialise - 
if (~isfield(CI.BC,'hx')) || (~isfield(CI.BC.hx,'isSetup') || CI.BC.hx.isSetup == false || CI.BC.hx.meanFlowCalc == false)
    % The heat exchanger parameters are:
    hx.D = CI.BC.hx.tubeDiameter; % heat exchanger tube diameter
    hx.Xp = CI.BC.hx.Xp; % lateral tube centre distance / tube diameter
    hx.Xl = CI.BC.hx.Xl; % longitudinal tube centre distance / tube diameter
    hx.nRows = CI.BC.hx.nRows; % number of tube rows
    hx.HTF = @(s) polyval(CI.BC.hx.htfNumerator,s)/polyval(CI.BC.hx.htfDenominator,s);
    hx.P1m = CI.TP.p_mean(1,end);
    hx.T1m = CI.TP.T_mean(1,end);
    hx.u1m = CI.TP.u_mean(1,end);
    hx.R = CI.R_air;
    hx.gamma = CI.TP.gamma(1,end);
    hx.Krow = CI.BC.hx.lossCoeff;

    rho1m = hx.P1m/(hx.R*hx.T1m);

    hx.A1 = 1; %arbitrary
    hx.Qm = CI.BC.hx.qm*hx.A1*hx.u1m*rho1m; %mean heat exchanger heat transfer rate
    hx.meanFlowCalc = false;
else
    %otherwise, load heat exchanger structure with mean flow
    %properties from previous calculation
    hx = CI.BC.hx.hxTemp;
    hx.meanFlowCalc = true;
end

%Calculate the acoustic response (transfer matrices) for the heat exchanger
%assembly. If the mean flow properties have not been calculated, this will
%be done (will not be re-calculated unless the heat exchanger properties or
%system mean flow properties are changed by the user)
hx = HX_OSCILOS(hx,s);

%Extract heat exchanger outlet mean pressure, temperature and velocity
endDuct.P1m = hx.PNm;
endDuct.T1m = hx.TNm;
endDuct.u1m = hx.uNm;
%Extract the length of the duct downstream of the heat exchanger
endDuct.L = CI.BC.hx.ductLength;
endDuct.gamma = hx.gamma;
endDuct.R = hx.R;

%Find the transfer matrix of the section of duct between the heat exchanger
%and the system outlet.
[endDuct.P2m, endDuct.T2m, endDuct.u2m, endDuct.T12] = ...
    Propagation_OSCILOS(endDuct.P1m,endDuct.T1m,endDuct.u1m,endDuct.L,endDuct.gamma,endDuct.R,s);

%select the acoustic boundary condition at the system outlet
switch CI.BC.hx.endCondition
    case 1 %choked - FROM ORIGINAL CODE
        gamma   = CI.TP.gamma(1,end);
        M2      = CI.TP.M_mean(1,end);
        TEMP    = (gamma-1)*M2/2;
        R2End  = (1-TEMP)/(1+TEMP);
    case 2 %open
        R2End = -1;
    case 3 %closed
        R2End = 1;
end

%Entropic reflection coefficient from the original code - for choked.
%Still used if the end condition is closed or open, but in these cases it
%makes no difference because no entropy waves propagate to the outlet.
RsEnd = -0.5*CI.TP.M_mean(1,end)./(1 + 0.5*(CI.TP.gamma(1,end) - 1 ).*CI.TP.M_mean(1,end));

%Apply the entropy dissipation/dispersion - 
Te = Fcn_TF_entropy_convection(s);
endDuct.T12(3,3) = endDuct.T12(3,3)*Te;
%Find the transfer matrix for the combined heat exchanger and remaining
%duct
endTransfer = endDuct.T12 * hx.Thx;

%Manipulate this transfer matrix with the system outlet reflection
%coefficients to find the reflection coefficients measurable at the heat
%exchanger inlet ->
% b = [  1  ,  0  ,-endTransfer(1,2);...
%      R2End,RsEnd,-endTransfer(2,2);...
%        0  ,  1  ,-endTransfer(3,2)];
% a_old = b\endTransfer;
% Rs_old = a_old(3,3);
% R2_old = a_old(3,1);

%when the growth rate is very positive, the entropy
%wave can grow very quickly indeed. This corresponds to very large values
%associated with the entropy wave in the transfer matrix, which makes the
%'b' matrix very close to being singular -> to avoid potential errors, the
%inversion procedure is calculated algebraically in the code below ->
a = [(endTransfer(2,2)-endTransfer(3,2)*RsEnd),-endTransfer(1,2),endTransfer(1,2)*RsEnd;...
     R2End*endTransfer(3,2),-endTransfer(3,2),-(endTransfer(1,2)*R2End-endTransfer(2,2));...
     R2End,-1,RsEnd]*endTransfer(:,[1,3])./(endTransfer(2,2)-endTransfer(3,2)*RsEnd...
     -endTransfer(1,2)*R2End);
Rs = a(3,2);
R2 = a(3,1);

% %Check for any errors in the heat exchanger calculations
% if hx.err == true
% warndlg(['An error occured in calculating the heat exchanger behavior. ',...
%         'This may be because the iterative mean flow solver failed. Is the Mach number',...
%         ' sensible? Is the heat transfer sensible?'],'PANIC!','replace');
% end

%----------------------Entropy convection transfer function ---------------
% TAKEN FROM Fcn_DetEqn.m (and modified to use CI.BC.hx.ET NOT CI.BC.ET entropy parameters)!!!!
function Te = Fcn_TF_entropy_convection(s) 
global CI
tau     = CI.BC.hx.ET.Dispersion.Delta_tauCs; %USING HEAT EXCHANGER ENTROPY CONVECTION PARAMETERS
k       = CI.BC.hx.ET.Dissipation.k;
switch CI.BC.hx.ET.pop_type_model
    case 1
        Te = k;
    case 2
        Te = k.*exp((tau.*s).^2./4);
    case 3
        if tau == 0
            tau = eps;
        end
        Te = k.*(exp(tau*s) - exp(-tau*s))./(2*tau*s); %consistent with email discussion on 12/07/2019 
%       Te = k.*sinc(tau*s./pi);                       %between Dong, Aimee and bertie

end                        
%



