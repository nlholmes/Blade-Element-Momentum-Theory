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