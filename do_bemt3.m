function DATA = do_bemt(DATA)

if DATA.anal_type == 1 % theta_0 given, ideal twist not possible with this option
    % linear twist, given theta_0
    DATA = do_bemt_given_theta0(DATA);
elseif DATA.anal_type == 2 % CT given, linear or ideal twist possible
  if DATA.twist_type == 1
    % linear twist, given CT
    CT_err = 100;
    Clalf = DATA.Cla*180/pi;
    % *** What is theta_tw? Ans: pitch angle at tip - pitch angle at hub
    % So theta_tw = tip twist - collective pitch (theta_tip - theta0)
    theta_tw = DATA.tip_twist - DATA.theta0; % but this isn't supposed to depend on theta0...
    DATA.theta_0 = 6.*DATA.CT_req./(DATA.solidity.*Clalf) - 3/4.*theta_tw + 3/2.*sqrt(DATA.CT_req./2); %%% Eq. 3.76, may need to change CT_req to CT in read_inputs.m, tho its another var in 3.77
    iter = 0;
    while abs(CT_err) >= 1e-6 % MIGHT NEED TO CONVERT CLALF TO RADS AT ALL LOCS THAT USE IT IN THE ENTIRE CODE
      iter = iter + 1;
      DATA = do_bemt_given_theta0(DATA);
      CT_out = DATA.CT;
      CT_err = DATA.CT_req - CT_out;
      theta_0 = DATA.theta0 + (6.*(DATA.CT_req - DATA.CT./(DATA.solidity.*Clalf)) + 3.*sqrt(2)./4.*(sqrt(DATA.CT_req) - sqrt(DATA.CT))); %%% Eq. 3.77
      DATA.theta_0 = real(theta_0);  %% Fix to handle imaginary numbers for lambda that the book doesn't mention
    end
  elseif DATA.twist_type == 2
    % ideal twist, given CT
    DATA = do_bemt_given_theta0(DATA);
    DATA = exact_ideal(DATA);  % caculate exact solution for comparison
  else
    error('Twist Type has to be either 1 or 2');      
  end
else
  error('Analysis Type has to be either 1 or 2');
end

return

function DATA = do_bemt_given_theta0(DATA)

DATA.theta = (DATA.theta0 + DATA.twist)*pi/180;
Clalf = DATA.Cla*180/pi; % used in DATA.lambda

%
% tip loss off (F = 1)
%
DATA.F = ones(1,DATA.Ns);
% lambda could be sqrt(CT/2) as we do only hover in this code
DATA.lambda = DATA.solidity.*Clalf./(16).*(sqrt(1 + 32.*DATA.theta.*DATA.R./(DATA.solidity.*Clalf)) - 1); %%% write your own
DATA.phi = DATA.lambda./DATA.R; %%% write your own

if DATA.tip_loss_option == 1
  %
  % tip loss on
  %
  lambda_err = 100;
  lambda_prev = DATA.lambda;
  iter_tip = 0;
  while lambda_err >= 1e-3
    iter_tip = iter_tip+1;
    f = Nb/2*((1 - DATA.R)./(DATA.R.*DATA.phi)); %%% Eq. 3.121
    DATA.F = (2/pi).*acos(exp(-f)); %%% Eq. 3.120
    % Below uses local solidity as opposed to DATA.rotor_solidity
    DATA.lambda = DATA.solidity.*Clalf./(16.*DATA.F).*(sqrt(1 + 32.*DATA.F.*DATA.theta.*DATA.R./(DATA.solidity.*Clalf)) - 1); %%%% Eq. 3.126
    DATA.lambda = real(DATA.lambda);  %% Fix to handle imaginary numbers for lambda that the book doesn't mention
    DATA.phi = DATA.lambda./DATA.r;
    lambda_err = max(abs(DATA.lambda-lambda_prev));
    lambda_prev = DATA.lambda;
  end
end

DATA.dCT = DATA.solidity.*Clalf./2.*(DATA.theta - DATA.lambda./DATA.R).*DATA.R.^2.*DATA.dr; %%% write your own, p.110 notes
% what is alpha_tip???
alpha_tip = DATA.theta - DATA.lambda; % p.110 of notes
DATA.CT = DATA.solidity.*Clalf./4.*alpha_tip; %%% write your own

DATA.theta = theta; % theta is theta_tip/R
DATA.alpha = theta - DATA.phi; % bit diff in notes??
DATA.Cl = 4.*DATA.CT./DATA.solidity.*(1./DATA.R); %%% write your own

CT = DATA.CT;

return

function DATA = exact_ideal(DATA)

N = 200;   % we are using N segments for this exact solution
dr = 1/N;
r = 0.5*dr:dr:1;
sigma = DATA.rotor_solidity;
CTreq = DATA.CT_req;
Cla = 2*pi;  % lift-curve slope is hardwired to 2*pi /rad for this exact soln.

theta_tip = 4*CTreq/(sigma*Cla) + sqrt(CTreq/2);
theta = theta_tip./r;
%
% capping theta at r = 0.2;
%
%index = find(r<=0.2);
%theta(index) = theta_tip/0.2;

lambda = (sigma*Cla/16)*(sqrt(1 + 32*theta.*r/(sigma*Cla)) - 1);
dCT = (sigma*Cla/2)*(theta.*(r.^2) - lambda.*r)*dr;
CT = sum(dCT);
alpha_tip = theta_tip - lambda(1);
Cl = Cla*(alpha_tip./r);

DATA.exact_dr = dr;
DATA.exact_r = r;
DATA.exact_theta = theta;
DATA.exact_lambda = lambda;
DATA.exact_dCT = dCT;
DATA.exact_CT = CT;
DATA.exact_Cl = Cl;

return