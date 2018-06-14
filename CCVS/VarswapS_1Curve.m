%By: Juncheng Li;
%Date: 2018/03/21;
%Contact: jlicv@connect.ust.hk;
%This is the calibration function for varswap curve on the variance asset,
%implemented with Monte Carlo approach and the model specified in section2.
%Remark: Without loss of generality, comments are referring to the code line right beneath;

function[varswapS_1_curve,time] = VarswapS_1Curve(T,Npath,K)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part0: Initialization-------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(7124);
tic
timesteps = 252*T;
N = timesteps;
dt = T/timesteps;
%The swap are agreed upon at 0 value, so the strike equal to the expected
%variance.
S0_1 = 1;
kappa_1 = 0.4;
xi_1 = 0.2;
u0_1 = 0;
rho_x1_u1 = -0.5;
m = 0.5;
%Note that in actual computation, sigma0_1 = 0.2*(1+m) = 0.3;
sigma0_1 = 0.2;

corr_matrix = [1 rho_x1_u1;rho_x1_u1 1];
F = chol(corr_matrix)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Part1: Diffusion Simulation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
g_x1 = randn(Npath,timesteps);
g_u1 = randn(Npath,timesteps);

dWx_1 = F(1,1) * g_x1 + F(1,2) * g_u1;
dWu_1 = F(2,1) * g_x1 + F(2,2) * g_u1;

u_1 = zeros(Npath,timesteps+1);
v_1 = zeros(Npath,timesteps+1);
u_1(:,1) = u0_1;
v_1(:,1) = exp(-xi_1^2/(4*kappa_1));

dx_1 = zeros(Npath,timesteps);
S_1 = zeros(Npath,timesteps+1);
S_1(:,1) = S0_1;

for i = 1:timesteps
    du_1 = -kappa_1*u_1(:,i)*dt + xi_1*sqrt(dt)*dWu_1(:,i);
    u_1(:,i+1) = u_1(:,i) + du_1;
    v_1(:,i+1) = exp(u_1(:,i+1)-xi_1^2/(4*kappa_1)*(1-exp(-2*kappa_1*(i+1)*dt)));
end

for i = 1:timesteps
    sigma_lv = sigma0_1*(m*S_1(:,i)+1);
    dx_1(:,i) = -0.5*sigma_lv.^2.*v_1(:,i)*dt + sqrt(dt.*v_1(:,i)).*sigma_lv.*dWx_1(:,i);
    S_1(:,i+1) = S_1(:,i).*exp(dx_1(:,i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part2: Payoff Calculation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Below 9 lines are only for convenience of diagnosis.
%Monthly data is often available.
% interval = 1; 
% annualized_ftr = 252/interval;
%approximate sigma_1_t with the discretized log return;
%Then apply the formula mentioned in section 4 to get the sigma_1_t^2;
%Partial T in such formula corresponds to the annualize_ftr here.
% variance_1_t_interval_dot = [(sigma0_1*(1+m*S0_1))^2,annualized_ftr*sum(reshape(dx_1.^2,Npath*interval,timesteps/interval),1)/Npath];
%If evaluation region is beyond the range of input, NaN will be generated.
% varswapS_1_curve = interp1(0:(1/annualized_ftr):T,variance_1_t_interval_dot,dt:dt:T);

rlzd_var = 252*cumsum(sum(dx_1.^2,1)/Npath)./(1:timesteps);
varswapS_1_curve = rlzd_var - K^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part3: Print Results & Parameters---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderName = 'Outputs';
fID = fopen(sprintf('%s/VarSwapS1_quadratic_localvol_report_%s.txt',FolderName,datestr(now,'yyyy-mm-dd HH-MM-SS')),'wt');
parameters_array = {'Strike(Moneyness)','Time to Mature(Yrs)','Number of Samples'...
    ,'kappa_1','xi_1','localvol_S0_1','S0_1','u0_1','rho_x1_u1';...
    K,T,N,kappa_1,xi_1,sigma0_1,S0_1,u0_1,rho_x1_u1};
para_string = sprintf('%s:%3.2f;\n',parameters_array{:});
fprintf(fID,para_string);
time = toc;
output_array = {'Time consumed is','Number of path simulated is';time,Npath};
string = sprintf('%s:%d;\n',output_array{:});
fprintf(fID,string);
fclose(fID);

end
