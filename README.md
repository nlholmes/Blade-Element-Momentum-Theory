# Blade-Element-Momentum-Theory

Final project from the course V/STOL Aerodynamics. 
Performs BEMT calculations given an input text file in the format:

5         % Rotor radius
2         % Number of blades
40        % Number of segments
1         % Planform type, 1 - linear, 2 - optimum (not implemented)
0.7854    % Root chord
0.7854    % Tip chord
2         % Twist type, 1 - linear, 2 - ideal
-10       % Tip twist (deg) relative to root
0         % Airfoil Cd0
0         % Airfoil Cd1
0         % Airfoil Cd2
0.1097    % Airfoil Cla
0         % Prandtl tip loss, 0 - Off, 1 - On
2         % Analysis type, 1 - theta_0 given, 2 - CT given
0         % theta_0 in deg
0.008     % CT
