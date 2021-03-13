function DATA = do_bemt_given_theta0(DATA)

%DATA.theta = (DATA.theta0 + DATA.twist)*pi/180;
% Trying theta_tip/r, which is DATA.twist, did nothing
% UNTIL CHANGED R to r in code, and then it linearized things for prob1a,
% also had to convert to rads

%** ADDED THETA0 FOR PROBLEM 2 to equation DUE TO CONVERGENCE ISSUES
% seems to have simply lowered the number, prevented theta0 in do_bemt
% while loop from changing
%*** Adding it in here messed up problem 1 by offset, but it was needed to
% fix problem 2 convergence, changed theta0 val in prob1a.in to 0 and then
% the problem was fixed. Seems to have just been an input issue.
%**** Adding it also messed up prob1b, offset to right and not correct
% trend
%***** NVM, just had to remove the theta0 = 10 from all prob1b input fi;
DATA.theta = (DATA.theta0 + DATA.twist)*pi/180;
Clalf = DATA.Cla*180/pi; % used in DATA.lambda ******MIGHT NEED TO BE IN RADS

%
% tip loss off (F = 1), the option = 0
%
DATA.F = ones(1,DATA.Ns);
% lambda could be sqrt(CT/2) as we do only hover in this code
%DATA.lambda = DATA.solidity.*Clalf./(16).*(sqrt(1 + 32.*DATA.theta.*DATA.R./(DATA.solidity.*Clalf)) - 1); %%% write your own
% Lambda is const in ideal twist case
%DATA.lambda = sqrt(DATA.CT_req./2); % changed it from above ******* works for prob1a
%** CHANGED BACK to other equation (p. 106 in notes), but UPDATED .R to .r (fixed prob 2, no
% issues created for problem 1)
% ***** CHANGED TO rotor_solidity as did for the other lambda equation, as
% it impacts phi, which impacts that lambda later through tip loss
%           THIS WAS INCORRECT --- CHANGED BACK AS CHANGED do_bemt TO USE
%           rotor_solidity for theta0 instead of lambda calculation
DATA.lambda = DATA.solidity.*Clalf./(16).*(sqrt(1 + 32.*DATA.theta.*DATA.r./(DATA.solidity.*Clalf)) - 1);
% Changed to r from R as did for others
DATA.phi = DATA.lambda./DATA.r; %%% write your own

if DATA.tip_loss_option == 1
  %
  % tip loss on
  %
  lambda_err = 100;
  lambda_prev = DATA.lambda;
  iter_tip = 0;
  while lambda_err >= 1e-3
    iter_tip = iter_tip+1;
    %** CHANGED .R to .r for prob 2
    f = DATA.Nb./2.*((1 - DATA.r)./(DATA.r.*DATA.phi)); %%% Eq. 3.121
    DATA.F = (2/pi).*acos(exp(-f)); %%% Eq. 3.120
    % Below uses local solidity as opposed to DATA.rotor_solidity
    % Changed capital R to r as did below for dCT equation, as is supposed
    % to be as in book, still not linear
    % ***** CHANGED solidity to rotor_solidity for Problem 5, fixed it a bit but not completely
    %               THIS WAS INCORRECT -- CHANGED BACK, see lambda calculation above
    DATA.lambda = DATA.solidity.*Clalf./(16.*DATA.F).*(sqrt(1 + 32.*DATA.F.*DATA.theta.*DATA.r./(DATA.solidity.*Clalf)) - 1); %%%% Eq. 3.126
    DATA.lambda = real(DATA.lambda);  %% Fix to handle imaginary numbers for lambda that the book doesn't mention
    DATA.phi = DATA.lambda./DATA.r;
    lambda_err = max(abs(DATA.lambda-lambda_prev));
    lambda_prev = DATA.lambda;
  end
end

% changed DATA.R to DATA.r --- *** HELPED, but still not linear
DATA.dCT = DATA.solidity.*Clalf./2.*(DATA.theta - DATA.lambda./DATA.r).*DATA.r.^2.*DATA.dr; %%% write your own, p.110 notes
% Changed to rotor_solidity, but didn't do anthing for prob1a
% Then converted Clalf back to rads, did nothing
%DATA.dCT = DATA.solidity.*(Clalf.*pi./180)./2.*(DATA.theta - DATA.lambda./DATA.R).*DATA.R.^2.*DATA.dr;
% what is alpha_tip???
%alpha_tip = DATA.theta - DATA.lambda; % p.110 of notes
%DATA.CT = DATA.solidity.*Clalf./4.*alpha_tip; %%% write your own
% Trying this, FIXED it
DATA.CT = sum(DATA.dCT);


%DATA.theta = theta; % theta is theta_tip/R
% Try this way, maybe he had it backwards
%theta = DATA.theta; % HE SAID TO COMMENT THIS OUT, also changed theta
%below to DATA.theta
DATA.alpha = DATA.theta - DATA.phi; % bit diff in notes??
% CHANGED R to r below
DATA.Cl = 4.*DATA.CT./DATA.solidity.*(1./DATA.r); %%% write your own
% Also CHANGED formula to include DATA.alpha --- FIXED IT
DATA.Cl = Clalf.*DATA.alpha; % ch.3 p.111 of notes

CT = DATA.CT;

return