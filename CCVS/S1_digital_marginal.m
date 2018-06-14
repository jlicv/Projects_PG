%By: Juncheng Li;
%Date: 2018/03/21;
%Contact: jlicv@connect.ust.hk;
%This is the calibration function for marginal density of the corridor
%asset, implemented with Monte Carlo approach and the model specified in section2.
%Remark: Without loss of generality, comments are referring to the code line right beneath;

function[S_1_distribution,time,S_1_sd] = S1_digital_marginal(T,Npath,K_bin_size,binwidth)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part0: Initialization-------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(3721);
tic
xi_1 = 0.2;
kappa_1 = 0.4;
u0_1 = 0;
timesteps = round(252*(T/1));
N = timesteps;
dt = T/timesteps;
S0_1 = 1;
rhox_1u_1 = -0.5;
m = 0.5;
sigma0_1 = 0.2;

S_1 = zeros(Npath,timesteps+1);
S_1(:,1) = S0_1;
u_1 = zeros(Npath,timesteps+1);
v_1 = zeros(Npath,timesteps+1);
dx_1 = zeros(Npath,timesteps);
u_1(:,1) = u0_1;
v_1(:,1) = 1;

sigma = [1 rhox_1u_1 ; rhox_1u_1 1];
F = chol(sigma)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Part1: Diffusion Simulation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gx_1 = randn(Npath/2,timesteps);
gx_1 = [gx_1;-gx_1];
gu_1 = randn(Npath/2,timesteps);
gu_1 = [gu_1;-gu_1];
dWx_1 = F(1,1) * gx_1 + F(1,2) * gu_1;
dWu_1 = F(2,1) * gx_1 + F(2,2) * gu_1;

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
S_1_distribution = zeros(K_bin_size,timesteps+1);
S_1_sd = zeros(K_bin_size,timesteps+1);
for i = 1:K_bin_size
    k = i*binwidth;
    F = S_1<=k;
    S_1_distribution(i,:) = mean(F);
    S_1_sd(i,:) = std(F)/sqrt(Npath);
end

time = toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part3: Print Results & Parameters---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filepath = mfilename('fullpath');
[startindex,endindex] = regexp(filepath,'.*\\');
outputPathName = filepath(startindex:endindex);
OutputFolderName = 'Outputs';
OutputFolderPath = strcat(outputPathName,OutputFolderName);
S1_marginal_mat_name = sprintf('%s/S1_marginal_density_%s_Kbin%d_binwidth%3.2f.mat',OutputFolderPath,datestr(now,'yyyy-mm-dd HH-MM-SS'),K_bin_size,binwidth);
save(S1_marginal_mat_name,'S_1_distribution','S_1_sd');
S1_marginal_csv_name = sprintf('%s/S1_marginal_density_%s_Kbin%d_binwidth%3.2f.csv',OutputFolderPath,datestr(now,'yyyy-mm-dd HH-MM-SS'),K_bin_size,binwidth);
csvwrite(S1_marginal_csv_name,S_1_distribution);
fID = fopen(sprintf('%s/S1_digital_marginal_put_report_%s.txt',OutputFolderPath,datestr(now,'yyyy-mm-dd HH-MM-SS')),'wt');
parameters_array = {'Time to Mature(Yrs)','Number of Samples'...
    ,'localvol_1','S0_1','u0_1','rhox_1u_1'; T,N,sigma0_1,S0_1,u0_1,rhox_1u_1};
para_string = sprintf('%s:%3.2f;\n',parameters_array{:});
fprintf(fID,para_string);
output_array = {'Time consumed is','Number of path simulated is';time,Npath};
string = sprintf('%s:%d;\n',output_array{:});
fprintf(fID,string);
fclose(fID);
end
