function [P3m,T3m,u3m,T13,err,P2m,T2m,u2m] = Inlet_1_OSCILOS(P1m,T1m,u1m,A1,A3,gamma,R,Qm,HTF,s,tr)
%This function calculates the mean flow conditions and transfer matrix
%for a heat source and isentropic constriction. Here, the heat source is 
%BEFORE the constriction. 

%% Definitions 
%( underscore _ is replaced by 1,2,3 etc to denote location)

%P_m : mean pressure (Pa)
%T_m : mean temperature (K
%u_m : mean velocity (m/s)
%rho_m : mean density (m/s)
%c_ : speed of sound (m/s)
%M_m: mean Mach number
%qm : mean heat transfer per unit mass (J/kgK)
%HTF : handle to heat transfer function 
%f : frequency (Hz)
%gamma : ratio of specific heat capacities
%R : gas constant (J/kgK)
%Cp : specific heat at constant pressure (J/kgK)

%% Compute mean flow properties
%check if mean flow properties have already been calculated
if tr.isSetup == false
    %For heat source
    c1 = sqrt(gamma*R*T1m);
    M1m = u1m/c1;
    rho1m = P1m/(R*T1m);
    Cp = (gamma/(gamma-1))*R;
    qm = Qm/(rho1m*u1m*A1);

    b = (2/(gamma - 1))*((c1^2/u1m) + gamma*u1m); %intermediate in calculation
    a = ((-1 - gamma)/(gamma - 1)); %intermediate in calculation
    c = -(u1m^2 + (2*c1^2)/(gamma - 1) + (2*qm)); %intermediate in calculation
    u2m = (-b + sqrt(b^2 - 4*a*c))/(2*a);
    rho2m = (rho1m*u1m)/u2m;
    P2m = P1m + rho1m*u1m^2 - rho2m*u2m^2;
    T2m = P2m/(R*rho2m); 
    c2 = sqrt(gamma*R*T2m);
    M2m = u2m/c2;

    %For contraction
    A2 = A1;
    A2s = A2*(((gamma + 1)/2)^((gamma + 1)/(2*(gamma - 1))))*M2m*...
            (1 + ((gamma - 1)/2)*M2m^2)^(-((gamma + 1)/(2*(gamma - 1))));
            %intermediate in calculation
    A3s = A2s; %intermediate in calculation

    Mguess = M2m*(A2/A3);
    M3m = Find_Mach(gamma,A3,A3s,Mguess); %solves for the outlet Mach number
    P3m = P2m*((1 + ((gamma-1)/2)*M2m^2)/(1 + ((gamma-1)/2)*M3m^2))^...
                (gamma/(gamma-1));
    T3m = T2m*((1 + ((gamma-1)/2)*M2m^2)/(1 + ((gamma-1)/2)*M3m^2));
    rho3m = P3m/(R*T3m);
    c3 = sqrt(gamma*R*T3m);
    u3m = M3m*c3; 

    % Sanity check mean flow properties
    %For heat source
    %evaluate LHS and RHS of the conservation equations
    cont12LHS = rho1m*u1m; 
    cont12RHS = rho2m*u2m;
    momen12LHS = (P1m + rho1m*u1m^2);
    momen12RHS = (P2m + rho2m*u2m^2);
    energy12LHS = Cp*T1m + (1/2)*u1m^2 + qm;
    energy12RHS = Cp*T2m + (1/2)*u2m^2;

    %calculate, in relative terms, the violation of the conservation equations
    %for the mean flow
    errorMean1 = abs((cont12LHS-cont12RHS)/(cont12LHS+cont12RHS)) ...
                + abs((momen12LHS-momen12RHS)/(momen12LHS+momen12RHS))...
                + abs((energy12LHS-energy12RHS)/(energy12LHS+energy12RHS));

    %for contraction
    %evaluate LHS and RHS of the conservation equations
    A3s = A3*(((gamma + 1)/2)^((gamma + 1)/(2*(gamma - 1))))*M3m*...
            (1 + ((gamma - 1)/2)*M3m^2)^(-((gamma + 1)/(2*(gamma - 1))));
    cont23LHS = A2*rho2m*u2m;
    cont23RHS = A3*rho3m*u3m;
    isentrop23LHS = P2m/rho2m^gamma;
    isentrop23RHS = P3m/rho3m^gamma;
    energy23LHS = (gamma/(gamma-1))*(P2m/rho2m) + (1/2)*(u2m^2);
    energy23RHS = (gamma/(gamma-1))*(P3m/rho3m) + (1/2)*(u3m^2);

    %calculate, in relative terms, the violation of the conservation equations
    %for the mean flow
    errorMean2 = abs((cont23LHS-cont23RHS)/(cont23LHS+cont23RHS)) ...
                + abs((isentrop23LHS-isentrop23RHS)/(isentrop23LHS+isentrop23RHS))...
                + abs((energy23LHS-energy23RHS)/(energy23LHS+energy23RHS))...
                + abs((A3s-A2s)/(A3s+A2s));

    errorMean = errorMean1+errorMean2;

else
    c1 = sqrt(gamma*R*T1m);
    M1m = u1m/c1;
    rho1m = P1m/(R*T1m);
    Cp = (gamma/(gamma-1))*R;
    
    u2m = tr.u2m;
    T2m = tr.T2m;
    P2m = tr.P2m;
    rho2m = P2m/(R*T2m);
    c2 = sqrt(gamma*R*T2m);
    M2m = u2m/c2;
    
    u3m = tr.u3m;
    T3m = tr.T3m;
    P3m = tr.P3m;
    rho3m = P3m/(R*T3m);
    c3 = sqrt(gamma*R*T3m);
    M3m = u3m/c3;
end

%% Compute transfer function
F = zeros(6,9); %this is a matrix containing the SIX linearised conservation 
                %equations in NINE variables
                %(P1+,P1-,s1',P2+,P2-,s2',P3+,P3-,s3'). This matrix is
                %manipulated to find the transfer matrix, T13.      
% 0 = F * [P1+;P1-;s1';P2+;P2-;s2';P3+;P3-;s3']

C12temp = [(1/rho1m)*(((1/(gamma-1))+0.5*M1m^2)*(1+1/M1m)+1+M1m),...
        (1/rho1m)*(((1/(gamma-1))+0.5*M1m^2)*(1-1/M1m)+1-M1m),...
        -0.5*(((M1m^2)*c1^2)/Cp);...
         (1+2*M1m+M1m^2),(1-2*M1m+M1m^2),-((rho1m*M1m^2 * c1^2)/Cp);
         (M1m+1),(M1m-1),-((rho1m*M1m*c1^2)/Cp)]; %intermediate in calculation
D12temp = [(1/rho2m)*(((1/(gamma-1))+0.5*M2m^2)*(1+1/M2m)+1+M2m),...
        (1/rho2m)*(((1/(gamma-1))+0.5*M2m^2)*(1-1/M2m)+1-M2m),...
        -0.5*(((M2m^2)*c2^2)/Cp);...
         (1+2*M2m+M2m^2),(1-2*M2m+M2m^2),-((rho2m*c2^2 *M2m^2)/Cp);...
         (M2m+1)*(c1/c2),(M2m-1)*(c1/c2),-((rho2m*M2m*c1*c2)/Cp)];
            %intermediate in calculation
            
F(1:3,1:3) = F(1:3,1:3) + C12temp;
F(1:3,4:6) = F(1:3,4:6) - D12temp;

%here, because the heat source is first, ref = 1 
B = (Qm*HTF(s))/((rho1m*u1m)*A1*M1m*(c1^2)*rho1m);
F(1,1) = F(1,1) + B;
F(1,2) = F(1,2) - B;

A2=A1;
C23temp = [(1+M2m),(1-M2m),((rho2m*c2^2)/(Cp*(gamma-1)));...
         (A2/c2)*(M2m+1),(A2/c2)*(M2m-1),(A2/c2)*((-rho2m*M2m*c2^2)/Cp);...
         0,0,1]; %intermediate in calculation
D23temp = [(1+M3m)*(rho2m/rho3m),(1-M3m)*(rho2m/rho3m),(rho2m/rho3m)*((rho3m*c3^2)/(Cp*(gamma-1)));...
         (A3/c3)*(M3m+1),(A3/c3)*(M3m-1),(A3/c3)*((-rho3m*M3m*c3^2)/Cp);...
         0,0,1]; %intermediate in calculation
     
F(4:6,4:6) = F(4:6,4:6) + C23temp;
F(4:6,7:9) = F(4:6,7:9) - D23temp;

T123 = F(1:6,4:9)^-1 * -F(1:6,1:3);
T13 = T123(4:6,:);

%% Sanity check transfer function
%compute random input upstream and downstream travelling pressure waves and
%a convected entropy wave
%for heat source
P1pl = (1+rand)*10^5;
P1mi = (1+rand)*10^5;
s1 = rand;

%find the predicted outputs
out = T123(1:3,:)*[P1pl;P1mi;s1];
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
contPerturb12LHS = rho1pr*u1m + rho1m*u1pr;
contPerturb12RHS = rho2pr*u2m + rho2m*u2pr;
momenPerturb12LHS = P1pr + (rho1pr*u1m^2 + 2*rho1m*u1m*u1pr);
momenPerturb12RHS = P2pr + (rho2pr*u2m^2 + 2*rho2m*u2m*u2pr);
energyPerturb12LHS = (rho1pr*u1m+rho1m*u1pr)*((gamma/(gamma-1))*(P1m/rho1m)+0.5*u1m^2)...
                + rho1m*u1m*((gamma/(gamma-1))*(P1pr/rho1m - (P1m/rho1m^2)*rho1pr)...
                         + u1m*u1pr) + HTF(s)*Qm*(u1pr/u1m)*(1/A1);
energyPerturb12RHS = (rho2pr*u2m+rho2m*u2pr)*((gamma/(gamma-1))*(P2m/rho2m)+0.5*u2m^2)...
                + rho2m*u2m*((gamma/(gamma-1))*(P2pr/rho2m - (P2m/rho2m^2)*rho2pr)...
                         + u2m*u2pr);
                     
%calculate, in relative terms, the violation of the conservation equations
%in the perturbations
errorPerturbation12 = abs((contPerturb12LHS-contPerturb12RHS)/(contPerturb12LHS+contPerturb12RHS)) + ...
                   abs((momenPerturb12LHS-momenPerturb12RHS)/(momenPerturb12LHS+momenPerturb12RHS)) + ...
                   abs((energyPerturb12LHS-energyPerturb12RHS)/(energyPerturb12LHS+energyPerturb12RHS));

%for constriction

%find the predicted outputs
out = T123(4:6,:)*[P1pl;P1mi;s1];
P3pl = out(1);
P3mi = out(2);
s3 = out(3);

%find the 'pr - prime' Perturbuations in pressure, velocity and density
%upstream and downstream
P2pr = P2pl+P2mi;
u2pr = (P2pl-P2mi)/(rho2m*c2);
rho2pr = (P2pl+P2mi)/c2^2 - s2*(rho2m/Cp);
 
P3pr = P3pl+P3mi;
u3pr = (P3pl-P3mi)/(rho3m*c3);
rho3pr = (P3pl+P3mi)/c3^2 - s3*(rho3m/Cp);

%evaluate LHS and RHS of the conservation equations in the perturbations
contPerturb23LHS = A2*(rho2pr*u2m + rho2m*u2pr);
contPerturb23RHS = A3*(rho3pr*u3m + rho3m*u3pr);
isentropPerturb23LHS = P2pr/rho2m^gamma - ((gamma*P2m)/(rho2m^(gamma+1)))*rho2pr;
isentropPerturb23RHS = P3pr/rho3m^gamma - ((gamma*P3m)/(rho3m^(gamma+1)))*rho3pr;
energyPerturb23LHS = (gamma/(gamma-1))*(P2pr/rho2m - (P2m/rho2m^2)*rho2pr)...
                         + u2m*u2pr;
energyPerturb23RHS = (gamma/(gamma-1))*(P3pr/rho3m - (P3m/rho3m^2)*rho3pr)...
                         + u3m*u3pr;
                     
%calculate, in relative terms, the violation of the conservation equations
%in the perturbations
errorPerturbation23 = abs((contPerturb23LHS-contPerturb23RHS)/(contPerturb23LHS+contPerturb23RHS)) + ...
                   abs((isentropPerturb23LHS-isentropPerturb23RHS)/(isentropPerturb23LHS+isentropPerturb23RHS)) + ...
                   abs((energyPerturb23LHS-energyPerturb23RHS)/(energyPerturb23LHS+energyPerturb23RHS));

errorPerturbation = errorPerturbation12 + errorPerturbation23;
               
%% Check if the errors are significant
if tr.isSetup == false
    if errorPerturbation > 10^-5 || errorMean > 10^-4
        err = true;
    else 
        err = false;
    end
else
    if errorPerturbation > 10^-5 || tr.errInlet
        err = true;
    else 
        err = false;
    end
end

end