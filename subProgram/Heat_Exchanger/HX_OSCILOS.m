function [hx] = HX_OSCILOS(hx,s)
%This function calculates the mean flow conditions and transfer matrix
%for a heat exchanger consisting of rows of tubes in crossflow. Each tube 
%row is modelled using single tube row model 1.

%The heat exchanger parameters are contained within the structure 'hx'.
%The parameters of each tube row and each gap are contained within the
%structures 'tr' and 'gap'.

%Check if the mean flow properties have previously been calculated (and
%thus do not need to be re-calculated)
if hx.meanFlowCalc == false %if not calculated, re-initialise
    hx.A2 = ((hx.Xp-1)/hx.Xp)*hx.A1; %find constriction area
    hx.Qmrow = hx.Qm/hx.nRows; %equally distribute heat source over rows
    hx.gapLength = hx.Xl*hx.D; %gap between tube rows
    hx.err = false;
    hx.hxLength = hx.nRows * hx.D + (hx.nRows-1)*hx.gapLength;
end

hx.Thx = eye(3); 
for i = 1:hx.nRows %loop through tube rows
    if hx.meanFlowCalc == false %initialise the tube row if mean flow properties have not been calculated previously
        trTemp.isSetup = false; %mean flow properties need to be calculated/recalculated
        trTemp.A1 = hx.A1;
        trTemp.A2 = hx.A2;
        trTemp.gamma = hx.gamma;
        trTemp.R = hx.R;
        trTemp.HTF = hx.HTF;
        trTemp.Qm = hx.Qmrow;
        trTemp.K = hx.Krow;
        trTemp.L = hx.D;

        if i == 1 %if this is the first row, take in heat exchanger INLET properties
            trTemp.P1m = hx.P1m;
            trTemp.T1m = hx.T1m;
            trTemp.u1m = hx.u1m;
        else %if not, take from the outlet of the gap between the current and preceeding row
            trTemp.P1m = hx.gap(i-1).P2m;
            trTemp.T1m = hx.gap(i-1).T2m;
            trTemp.u1m = hx.gap(i-1).u2m;
        end
    else % otherwise use previously generated structure
        trTemp = hx.tr(i);
    end
    
    %calculate mean flow (if necessary) and acoustic properties of isolated
    %row
    hx.tr(i) = Single_Tube_Row_1_OSCILOS(trTemp,s);
    if hx.tr(i).err == true
        hx.err = true;
    end
    %add contribution to overall heat exchanger transfer matrix
    hx.Thx = hx.tr(i).T15*hx.Thx;
    
    if i ~= hx.nRows %if tube row is not the last, there is a gap over which the waves must propagate
        if hx.meanFlowCalc == false %again, check if mean flow already calculated
            hx.gap(i).P1m = hx.tr(i).P5m;
            hx.gap(i).T1m = hx.tr(i).T5m;
            hx.gap(i).u1m = hx.tr(i).u5m;
            hx.gap(i).L = hx.gapLength;
            hx.gap(i).gamma = hx.gamma;
            hx.gap(i).R = hx.R;
        end
        [hx.gap(i).P2m,hx.gap(i).T2m,hx.gap(i).u2m,hx.gap(i).T12] =...
            Propagation_OSCILOS(hx.gap(i).P1m,hx.gap(i).T1m,hx.gap(i).u1m,hx.gap(i).L,...
            hx.gap(i).gamma,hx.gap(i).R,s); %find gap transfer matrix 
        hx.Thx = hx.gap(i).T12*hx.Thx; %add contribution to overall heat exchanger transfer matrix
    else % if this is the final tube row, set outlet mean flow properties
        hx.PNm = hx.tr(i).P5m;
        hx.TNm = hx.tr(i).T5m;
        hx.uNm = hx.tr(i).u5m;
    end
end
end

