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
    %theta_tw = DATA.tip_twist;
    %** Updated field in structure to match one from read_inputs (theta_0 to theta0)
    % ***** CHANGED to rotor_solidity for problem 5
    %           FIXED -- SEE BELOW IN WHILE LOOP FOR DETAILS
    DATA.theta0 = 6.*DATA.CT_req./(DATA.rotor_solidity.*Clalf) - 3/4.*theta_tw + 3/2.*sqrt(DATA.CT_req./2); %%% Eq. 3.76, may need to change CT_req to CT in read_inputs.m, tho its another var in 3.77
    iter = 0;
    while abs(CT_err) >= 1e-6 % MIGHT NEED TO CONVERT CLALF TO RADS AT ALL LOCS THAT USE IT IN THE ENTIRE CODE
      iter = iter + 1;
      DATA = do_bemt_given_theta0(DATA);
      CT_out = DATA.CT;
      CT_err = DATA.CT_req - CT_out;
      %** Updated field in structure to match one from read_inputs (theta_0 to theta0)
      % ***** CHANGED to rotor_solidity for problem 5
      %         FIXED -- BUT NEEDED TO CHANGE BACK TO .solidity from
      %         rotor_solidity in the do_bemt_given_theta0 file for lambda
      %         calculations
      theta0 = DATA.theta0 + (6.*(DATA.CT_req - DATA.CT)./(DATA.rotor_solidity.*Clalf) + 3.*sqrt(2)./4.*(sqrt(DATA.CT_req) - sqrt(DATA.CT))); %%% Eq. 3.77
      %** Updated field in structure to match one from read_inputs (theta_0 to theta0)
      DATA.theta0 = real(theta0);  %% Fix to handle imaginary numbers for lambda that the book doesn't mention
      %abs(CT_err) % for testing
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