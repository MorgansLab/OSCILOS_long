function [P2m,T2m,u2m,T12,err] = Loss_Coefficient_Modified_OSCILOS(P1m,T1m,u1m,A1,A2,gamma,R,K,tr)
%This function calculates the mean flow conditions and transfer matrix
%for a quasi-steady flow irreversible expansion described using a loss coefficient.

%This version uses the INCOMPRESSIBLE definition for change in stagnation pressure
%and relates that to the loss coefficient and inlet dynamic head.

%(P1 + 0.5*rho1*u1^2) - (P2 + 0.5*rho2*u2^2) = K * 0.5*rho1*u1^2

%% Definitions 
%( underscore _ is replaced by 1 or 2 if the property describes
%the upstream or downstream state )

%P_m : mean pressure (Pa)
%T_m : mean temperature (K
%u_m : mean velocity (m/s)
%rho_m : mean density (m/s)
%c_ : speed of sound (m/s)
%M_m: mean Mach number
%qm : mean heat transfer per unit mass (J/kgK)
%L : section length (m) 
%f : frequency (Hz)
%gamma : ratio of specific heat capacities
%R : gas constant (J/kgK)
%Cp : specific heat at constant pressure (J/kgK)
%A_ : section area (m^2)
%K : loss coefficient as in dh = K*0.5*(u^2/2g) for head loss

%% Compute mean flow properties
%check if mean flow properties have already been calculated
if tr.isSetup == false
    c1 = sqrt(gamma*R*T1m);
    M1m = u1m/c1;
    rho1m = P1m/(R*T1m);
    Cp = (gamma/(gamma-1))*R;

    a = (1/2)*((A1*rho1m*u1m)/(A2))*(-1/gamma);
    b = (-(1/2)*K*rho1m*u1m^2 + P1m + (1/2)*rho1m*u1m^2);
    c = (-P1m*(A1/A2)*u1m - (1/2)*(u1m^2)*((gamma-1)/gamma)*((A1*rho1m*u1m)/A2));
    u2m = (-b+sqrt(b^2-4*a*c))/(2*a);
    rho2m = (A1*rho1m*u1m)/(A2*u2m);
    P2m = P1m*((A1*u1m)/(A2*u2m)) + (1/2)*(u1m^2)*((gamma-1)/gamma)*((A1*rho1m*u1m)/(A2*u2m))...
          -(1/2)*rho2m*(u2m^2)*((gamma-1)/gamma);
    T2m = P2m/(rho2m*R);
    c2 = sqrt(gamma*R*T2m);
    M2m = u2m/c2;

    % Sanity check mean flow properties
    %evaluate LHS and RHS of the conservation equations
    cont12LHS = A1*rho1m*u1m;
    cont12RHS = A2*rho2m*u2m;
    momen12LHS = P1m + (1/2)*rho1m*u1m^2 - ...
                    K*0.5*rho1m*u1m^2;
    momen12RHS = P2m + (1/2)*rho2m*u2m^2;
    energy12LHS = (gamma/(gamma-1))*(P1m/rho1m) + (1/2)*u1m^2;
    energy12RHS = (gamma/(gamma-1))*(P2m/rho2m) + (1/2)*u2m^2;

    %calculate, in relative terms, the violation of the conservation equations
    %for the mean flow
    errorMean = abs((cont12LHS-cont12RHS)/(cont12LHS+cont12RHS)) ...
                + abs((momen12LHS-momen12RHS)/(momen12LHS+momen12RHS))...
                + abs((energy12LHS-energy12RHS)/(energy12LHS+energy12RHS));
else
    c1 = sqrt(gamma*R*T1m);
    M1m = u1m/c1;
    rho1m = P1m/(R*T1m);
    Cp = (gamma/(gamma-1))*R;
    
    u2m = tr.u5m;
    P2m = tr.P5m;
    T2m = tr.T5m;
    rho2m = (A1*rho1m*u1m)/(A2*u2m);
    c2 = sqrt(gamma*R*T2m);
    M2m = u2m/c2;
end
        
%% Compute transfer function

% | P2pl |       | ? ? ? |   | P1pl |
% | P2mi |   =   | ? ? ? | * | P1mi |
% |  s2  |       | ? ? ? |   |  s1  |
%   [P2]           [T12]   *   [P1]

Ctemp = [(A1/c1)*(M1m+1),(A1/c1)*(M1m-1),(A1/c1)*((-rho1m*M1m*c1^2)/Cp);
         1+(1/2)*M1m^2+M1m-K*((1/2)*M1m^2+M1m),...
         1+(1/2)*M1m^2-M1m-K*((1/2)*M1m^2-M1m),...
         -(1/2)*((rho1m*u1m^2)/Cp)+K*(1/2)*((rho1m*u1m^2)/Cp);
         (1/rho1m)*(1+M1m),(1/rho1m)*(1-M1m),(c1^2)/(Cp*(gamma-1))];
        %intermediate in calculation
Dtemp = [(A2/c2)*(M2m+1),(A2/c2)*(M2m-1),(A2/c2)*((-rho2m*M2m*c2^2)/Cp);
         1+(1/2)*M2m^2+M2m,...
         1+(1/2)*M2m^2-M2m,...
         -(1/2)*((rho2m*u2m^2)/Cp);
         (1/rho2m)*(1+M2m),(1/rho2m)*(1-M2m),(c2^2)/(Cp*(gamma-1))];
        %intermediate in calculation
T12 = (Dtemp^-1)*Ctemp; %Transfer function for the expansion

%% Sanity check transfer function
%compute random input upstream and downstream travelling pressure waves and
%a convected entropy wave
P1pl = (1+rand)*10^5;
P1mi = (1+rand)*10^5;
s1 = rand;

%find the predicted outputs
out = T12*[P1pl;P1mi;s1];
P2pl = out(1);
P2mi = out(2);
s2 = out(3);

%find the 'pr - prime' Perturbuations in pressure, velocity and density
%upstream and downstream
P1pr = P1pl+P1mi;
u1pr = (P1pl-P1mi)/(rho1m*c1);
rho1pr = (P1pl+P1mi)/c1^2 - s1*(rho1m/Cp);

P2pr = P2pl+P2mi;
u2pr = (P2pl-P2mi)/(rho2m*c2);
rho2pr = (P2pl+P2mi)/c2^2 - s2*(rho2m/Cp);   

%evaluate LHS and RHS of the conservation equations in the perturbations
contFluct12LHS = A1*(rho1pr*u1m + rho1m*u1pr);
contFluct12RHS = A2*(rho2pr*u2m + rho2m*u2pr);
momenFluct12LHS = (P1pr + (1/2)*rho1pr*u1m^2 + rho1m*u1m*u1pr) ...
                   - K*((1/2)*rho1pr*u1m^2 + rho1m*u1m*u1pr);
momenFluct12RHS = (P2pr + (1/2)*rho2pr*u2m^2 + rho2m*u2m*u2pr);
energyFluct12LHS = (gamma/(gamma-1))*(P1pr/rho1m - (P1m/rho1m^2)*rho1pr)...
                         + u1m*u1pr;
energyFluct12RHS = (gamma/(gamma-1))*(P2pr/rho2m - (P2m/rho2m^2)*rho2pr)...
                         + u2m*u2pr;

%calculate, in relative terms, the violation of the conservation equations
%in the perturbations
errorFluctuation = abs((contFluct12LHS-contFluct12RHS)/(contFluct12LHS+contFluct12RHS)) + ...
                   abs((momenFluct12LHS-momenFluct12RHS)/(momenFluct12LHS+momenFluct12RHS)) + ...
                   abs((energyFluct12LHS-energyFluct12RHS)/(energyFluct12LHS+energyFluct12RHS));

%% Check if the errors are significant
if tr.isSetup == false
    if errorFluctuation > 10^-5 || errorMean > 10^-4
        err = true;
    else 
        err = false;
    end
else
    if errorFluctuation > 10^-5 || tr.errInlet
        err = true;
    else 
        err = false;
    end
end

end

