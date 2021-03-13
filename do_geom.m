function DATA = do_geom(DATA)

DATA.dr = 1/DATA.Ns; % increment for r
DATA.r = (DATA.dr/2):DATA.dr:1; % nondimensional radial values @ segment centers [0, 1]
DATA.y = (DATA.r).*(DATA.R); % dimensional radial values [0, R]
% root - slope.*xdistWhereNeedToEvaluate
DATA.chord = (DATA.cr) - ((DATA.cr)-(DATA.ct))/(DATA.R).*DATA.y; % chord vals @ seg centers
DATA.solidity = (DATA.Nb).*(DATA.chord)./(pi*DATA.R); % varies with chord so has many elems, corrected from 2pi to pi

% .solidity is local solidity, this here is rotor solidity
DATA.rotor_solidity = sum(DATA.solidity.*DATA.dr);


if DATA.twist_type == 1
  % linear twist
  DATA.twist = DATA.tip_twist .* DATA.r;
  %DATA.twist = linspace(0,DATA.tip_twist,DATA.Ns);
  %DATA.twist = 0:DATA.tip_twist;%%%% fill in your code %%%%
elseif DATA.twist_type == 2
  % ideal twist

  %%%% fill in your code %%%%
  %%%% we can do this later after we get other stuff working %%%%
  Cla = DATA.Cla*180/pi; % was CLa in calc and now is Cla
  % eq. 3.67:
  % theta_tip = 4*CT/sig*Cla + sqrt(CT/2), Cla in per rad (convert), sig is rot sol
  % Might need not to use CT_req, also keep note of the solidity used, migh
  % need to change that in the future elsewhere as well if something goes
  % wrong
  DATA.tip_twist = 4.*DATA.CT_req./(DATA.solidity.*Cla) + sqrt(DATA.CT_req./2); %% Eq. 3.67 from book for given CT %%
  % Changed to rotor solidity from local, no change for prob1a
  %DATA.tip_twist = 4.*DATA.CT_req./(DATA.rotor_solidity.*Cla) + sqrt(DATA.CT_req./2);
  DATA.tip_twist = DATA.tip_twist*180/pi; % converted to rads (or is it to degs??)
  DATA.twist = DATA.tip_twist./DATA.r;
  DATA.theta_0 = 0; % theta_0 should not be used, as pitch at hub = inf
  
else
  error('Twist type can only be 1 or 2');
end

return