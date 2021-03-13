function DATA = do_bemt_original(DATA)


% Iterative function, Lecture 23 gives CT expression talked about

% We'll write this function first for a given theta_0, and then modify
% it for a given CT

theta = (DATA.theta_0 + DATA.twist)*pi/180; % theta_0 given
Clalf = DATA.Cla*180/pi;

%
% tip loss off (F = 1)
%
DATA.F = ones(1,DATA.Nseg);
DATA.lambda = %%% write your own, use local solidity
DATA.phi = %%% write your own, local lambda times local r val

if DATA.tip_loss_option == 1
  %
  % tip loss on
  %
  % We'll add tip loss capability later

end

DATA.dCT = %%% write your own
DATA.CT = %%% write your own

DATA.theta = theta;
DATA.alpha = theta - DATA.phi;
DATA.Cl = %%% write your own

CT = DATA.CT;

return
%{
function DATA = do_bemt(DATA)

if DATA.anal_type == 1, % theta_0 given, ideal twist not possible with this option
    % linear twist, given theta_0
    DATA = do_bemt_given_theta0(DATA);
elseif DATA.anal_type ==2, % CT given, linear or ideal twist possible
  if DATA.twist_type == 1,
    % linear twist, given CT
    CT_err = 100;
    Clalf = DATA.Cla*180/pi;
    DATA.theta_0 = %%% Eq. 3.76
    iter = 0;
    while abs(CT_err) >= 1e-6,
      iter = iter + 1;
      DATA = do_bemt_given_theta0(DATA);
      CT_out = DATA.CT;
      CT_err = DATA.CT_req-CT_out;
      theta_0 = %%% Eq. 3.77
      DATA.theta_0 = real(theta_0);  %% Fix to handle imaginary numbers for lambda that the book doesn't mention
    end
  elseif DATA.twist_type == 2,
    % ideal twist, given CT
    DATA = do_bemt_given_theta0(DATA);
    DATA = exact_ideal(DATA);  % caculate exact solution for comparison
  else,
    error('Twist Type has to be either 1 or 2');      
  end
else,
  error('Analysis Type has to be either 1 or 2');
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DATA = do_bemt_given_theta0(DATA)

DATA.theta = (DATA.theta_0 + DATA.twist)*pi/180;
Clalf = DATA.Cla*180/pi;

%
% tip loss off (F = 1)
%
DATA.F = ones(1,DATA.Nseg);
DATA.lambda = %%% write your own
DATA.phi = %%% write your own

if DATA.tip_loss_option==1,
  %
  % tip loss on
  %
  lambda_err = 100;
  lambda_prev = DATA.lambda;
  iter_tip = 0;
  while lambda_err >= 1e-3
    iter_tip = iter_tip+1;
    f = %%% Eq. 3.121
    DATA.F = %%% Eq. 3.120
    DATA.lambda = %%%% Eq. 3.126
    DATA.lambda = real(DATA.lambda);  %% Fix to handle imaginary numbers for lambda that the book doesn't mention
    DATA.phi = DATA.lambda./DATA.r;
    lambda_err = max(abs(DATA.lambda-lambda_prev));
    lambda_prev = DATA.lambda;
  end
end

DATA.dCT = %%% write your own
DATA.CT = %%% write your own

DATA.theta = theta;
DATA.alpha = theta - DATA.phi;
DATA.Cl = %%% write your own

CT = DATA.CT;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%}