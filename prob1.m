clear all; close all; clc;
%% Problem 1
% Part A: Ideal twist, solidity = 0.1, CT = 0.008
%
%exact solution
r = 0:0.05:1;
CT = 0.008;
sol = 0.1;
lambda = sqrt(CT/2)*ones(length(r),1);
Clalf = 2*pi;
theta_tip = 4*CT/(sol*Clalf) + lambda(1);
theta = theta_tip./r;
alpha_tip = theta_tip - lambda(1);
dCT_dr = sol*Clalf*0.5*(theta_tip-lambda(1))*r;
Cl = Clalf*(alpha_tip./r);
%%
%bemt
%PROB1A = bemt('prob1_files/prob1a.in');
% bemt not working
%PROB1A = bemt('rect.in'); % for testing

%PROB1A = read_inputs('prob1a.in');
%PROB1A = do_geom(PROB1A);
%PROB1A = do_bemt(PROB1A);
%PROB1A = calc_power(PROB1A);
PROB1A = bemt('prob1a.in'); % seems like bemt func works now
%% plots for part a, file prob1a.in
subplot(2,2,1);
plot(PROB1A.r,PROB1A.twist./PROB1A.tip_twist,'-'); % changed to ./
set(gca,'XLim',[0 1],'YLim',[0 5]);
xlabel('r');
ylabel('Local pitch angle/tip pitch');
title('Blade twist');
%
subplot(2,2,2);
plot(PROB1A.exact_r,PROB1A.exact_lambda,'-');
hold on;
plot(PROB1A.r,PROB1A.lambda,'o');
legend('Exact solution','BEMT');
xlabel('r');
ylabel('\lambda_i');
set(gca,'YLim',[0.0632 0.0633]);
title('Inflow dist.');
%
subplot(2,2,3);
plot(PROB1A.exact_r,PROB1A.exact_dCT./PROB1A.exact_dr,'-');
hold on;
plot(PROB1A.r,PROB1A.dCT./PROB1A.dr,'o');
%legend('Exact solution','BEMT','Location','NorthWest');
xlabel('r');
ylabel('dC_T/dr');
title('Thrust dist.');
%
subplot(2,2,4);
plot(PROB1A.exact_r,PROB1A.exact_Cl,'-');
hold on;
plot(PROB1A.r,PROB1A.Cl,'o');
set(gca,'YLim',[0 2]);
%legend('Exact solution','BEMT','Location','NorthEast');
xlabel('r');
ylabel('C_l');
title('Lift coeff. dist.');
%
%% Part B: Ideal twist, solidity = 0.1, CT = 0 to 0.01, file prob1b.in
%
%exact solution
r = 0:0.05:1;
sol = 0.1;
CT = 0:0.001:0.01;
CPi = CT.^1.5/sqrt(2);
%%
%bemt
PROB1B_0 = bemt('prob1_files/prob1b_0.in');
PROB1B_2 = bemt('prob1_files/prob1b_2.in');
PROB1B_4 = bemt('prob1_files/prob1b_4.in');
PROB1B_6 = bemt('prob1_files/prob1b_6.in');
PROB1B_8 = bemt('prob1_files/prob1b_8.in');
PROB1B_10 = bemt('prob1_files/prob1b_10.in');
bemt_soln = [
    PROB1B_0.CT PROB1B_0.CPi,
    PROB1B_2.CT PROB1B_2.CPi,
    PROB1B_4.CT PROB1B_4.CPi,
    PROB1B_6.CT PROB1B_6.CPi,
    PROB1B_8.CT PROB1B_8.CPi,
    PROB1B_10.CT PROB1B_10.CPi];
figure;
plot(CT,CPi,'-');
hold on;
h = plot(bemt_soln(:,1),bemt_soln(:,2),'o');
set(h,'Clipping','Off');
set(gca,'XLim',[0 0.01],'YLim',[0 8e-4]);
legend('Exact','BEMT','Location','NorthWest');
xlabel('C_T');
ylabel('C_{Pi}');
title('C_{Pi} vs. C_T. Exact and BEMT Comparison');