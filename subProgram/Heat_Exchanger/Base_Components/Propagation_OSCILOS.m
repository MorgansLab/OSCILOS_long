function [P2m,T2m,u2m,T12] = Propagation_OSCILOS(P1m,T1m,u1m,L,gamma,R,s)
%This function calculates the mean flow conditions and transfer matrix
%for a uniform section of duct with mean flow.

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

%% Compute mean flow properties
c1 = sqrt(gamma*R*T1m);

u2m = u1m;
P2m = P1m;
T2m = T1m;

%Calculate transfer matrix

% | P2pl |       | ? ? ? |   | P1pl |
% | P2mi |   =   | ? ? ? | * | P1mi |
% |  s2  |       | ? ? ? |   |  s1  |
%   [P2]           [T12]   *   [P1]

T12 = [exp(-(s*L)/(c1+u1m)),0,0;
           0,exp((s*L)/(c1-u1m)),0;
           0,0,exp((-s*L)/u1m)]; %Transfer matrix for propagation section

end

