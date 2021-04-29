function [tr] = Single_Tube_Row_1_OSCILOS(tr,s)
%This function calculates the mean flow conditions and transfer matrix
%for an idealised isolated tube row approximated as a heat source,
%isentropic contraction, brief propagation and abrupt expansion. The heat
%source is modelled using the 'three equation model' and the abrupt expansion
%is modelled using a loss coefficient. See 'Predicting Instabilities in a 
%Rocket Engine Preburner - Final Report' (Bertie Boakes, MEng project 2019)
%for more information.

%THE HEAT SOURCE IS BEFORE THE CONTRACTION

%% Definitions 
%( underscore _ is replaced by the position index)

%P_m : mean pressure (Pa)
%T_m : mean temperature (K
%u_m : mean velocity (m/s)
%rho_m : mean density (m/s)
%c_ : speed of sound (m/s)
%M_m: mean Mach number
%Qm : mean heat transfer rate (W)
%L : section length (m) 
%f : frequency (Hz)
%gamma : ratio of specific heat capacities
%R : gas constant (J/kgK)
%Cp : specific heat at constant pressure (J/kgK)
%A_ : section area (m^2)
%K : abrupt expansion loss coefficient
%HTF : heat transfer function (Q'/Qm / u'/um)

%% Compute the heat source and contraction (inlet)

[tr.P3m,tr.T3m,tr.u3m,tr.T13,tr.errInlet,tr.P2m,tr.T2m,tr.u2m] = Inlet_1_OSCILOS(tr.P1m,tr.T1m,tr.u1m,tr.A1,tr.A2,tr.gamma,tr.R,tr.Qm,tr.HTF,s,tr);

%% Compute the propagation section

[tr.P4m,tr.T4m,tr.u4m,tr.T34] = Propagation_OSCILOS(tr.P3m,tr.T3m,tr.u3m,tr.L,tr.gamma,tr.R,s);

%% Compute the abrupt expansion

[tr.P5m,tr.T5m,tr.u5m,tr.T45,tr.errExpansion] = Loss_Coefficient_Modified_OSCILOS(tr.P4m,tr.T4m,tr.u4m,tr.A2,tr.A1,tr.gamma,tr.R,tr.K,tr);


%% Compute overall transfer matrix

tr.T15 = tr.T45*tr.T34*tr.T13;

tr.err = or(tr.errInlet,tr.errExpansion);

tr.isSetup = true; %tube row mean flow properties have been calculated...

end

