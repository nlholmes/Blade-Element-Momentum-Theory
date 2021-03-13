function DATA = calc_power(DATA)

% Induced power
DATA.dCPi = DATA.lambda.*DATA.dCT;
DATA.CPi = sum(DATA.dCPi);

% Profile power, use local solidity
DATA.Cd = DATA.Cd0 + DATA.Cd1.*DATA.alpha + DATA.Cd2.*(DATA.alpha.^2);
% CHANGED to r from R
DATA.dCP0 = DATA.solidity./2.*DATA.Cd.*DATA.r.^3.*DATA.dr; %%%% Delta CP0 which can be summed in next statement below, p.118 of notes (used)
DATA.CP0 = sum(DATA.dCP0); %%% summation version of Eq. 3.116

% Figure of merit
% CHANGED: ^ to .^ so might be wrong
CP_ideal = DATA.CT.^1.5/sqrt(2);
% CHANGED to ./ from /
DATA.K = DATA.CPi./CP_ideal;
DATA.CP = DATA.CPi + DATA.CP0;
DATA.dCP = DATA.dCPi + DATA.dCP0;
% CHANGED to ./ from /
DATA.FM = CP_ideal./(DATA.CPi + DATA.CP0); %%% FM from Eq. 3.129 or chapter 2

return