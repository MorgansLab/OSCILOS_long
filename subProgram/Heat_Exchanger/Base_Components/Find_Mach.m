function [M, i, err] = Find_Mach(gamma,A,As,M0)
%This function solves an isentropic relation to find the Mach number of
%the flow which has a choked area As and an actual area A. M0 is the first
%guess.

%find the solution by gradient descent + Armijo line search

maxIts = 1000;
tol = 10^-16; %error tolerance
err = 1; %placeholder error
dx = 0.000000001; %step used to calculate derivative
Fi = F(M0); %initial F
Mi = M0; %initial M
a = 0.1; %guess step size
sigma = 0.7; %for Armijo linesearch
i = 0; %counter

while err > tol && i <maxIts
    dfdx = (F(Mi+dx) - F(Mi))/dx; %Find derivative
    if dfdx == 0 %check if it is a minimum
        M = Mi;
        return %if so, return result
    end
    d = -dfdx; %set the search direction to the anti gradient
    
    phi = 1; %need to set phi = 0 to loop through for Armijo
    j = 0; %for iterating on alpha
    while phi > 0
        alpha = a*sigma^j; %iterate for alpha
        phi = F(Mi+d*alpha) - Fi - 0.5*dfdx*d*alpha; %find reduction w.r.t armijo line
        j = j+1;
    end
    
    Mold = Mi; %store last M
    Mi = Mold + d*alpha; %update M
    Fold = Fi; %store last F
    Fi = F(Mi); %update F
    err = Fi; %calculate error
    i = i + 1;
end

M = Mi; %return M
% disp(['findMach iterations: ' num2str(i)])

function eval = F(M)
        eval = (A*(((gamma+1)/2)^((gamma+1)/(2*(gamma-1))))*M*...
    (1+((gamma-1)/2)*M^2)^-((gamma+1)/(2*(gamma-1))) - As)^2;
    % this expression is zero when the isentropic relations are satisfied
end

end

