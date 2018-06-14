%By: Juncheng Li;
%Date: 2018/03/21;
%Contact: jlicv@connect.ust.hk;
%This is the calibration function for marginal density of the corridor
%asset, implemented with Monte Carlo approach and the model specified in section2.
%Remark: Without loss of generality, comments are referring to the code line right beneath;

function[S_2_distribution,time,S_2_sd] = S2_digital_marginal(T,Npath,K_bin_size,binwidth)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part0: Initialization-------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(7124);
tic
xi_2 = 0.2;
kappa_2 = 0.4;
u0_2 = 0;
timesteps = round(252*(T/1));
N = timesteps;
dt = T/timesteps;
S0_2 = 1;
rhox_2u_2 = -0.5;
m = 0.5;
sigma0_2 = 0.2;

S_2 = zeros(Npath,timesteps+1);
S_2(:,1) = S0_2;
u_2 = zeros(Npath,timesteps+1);
v_2 = zeros(Npath,timesteps+1);
dx_2 = zeros(Npath,timesteps);
u_2(:,1) = u0_2;
v_2(:,1) = 1;

sigma = [1 rhox_2u_2 ; rhox_2u_2 1];
F = chol(sigma)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Part1: Diffusion Simulation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gx_2 = randn(Npath/2,timesteps);
gx_2 = [gx_2;-gx_2];
gu_2 = randn(Npath/2,timesteps);
gu_2 = [gu_2;-gu_2];
dWx_2 = F(1,1) * gx_2 + F(1,2) * gu_2;
dWu_2 = F(2,1) * gx_2 + F(2,2) * gu_2;

for i = 1:timesteps
    du_2 = -kappa_2*u_2(:,i)*dt + xi_2*sqrt(dt)*dWu_2(:,i);
    u_2(:,i+1) = u_2(:,i) + du_2;
    v_2(:,i+1) = exp(u_2(:,i+1)-xi_2^2/(4*kappa_2)*(1-exp(-2*kappa_2*(i+1)*dt)));
end

for i = 1:timesteps
    sigma_lv = sigma0_2*(m*S_2(:,i)+1);
    dx_2(:,i) = -0.5*sigma_lv.^2.*v_2(:,i)*dt + sqrt(dt.*v_2(:,i)).*sigma_lv.*dWx_2(:,i);
    S_2(:,i+1) = S_2(:,i).*exp(dx_2(:,i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part2: Payoff Calculation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_2_distribution = zeros(K_bin_size,timesteps+1);
S_2_sd = zeros(K_bin_size,timesteps+1);
for i = 1:K_bin_size
    k = i*binwidth;
    F = S_2<=k;
    S_2_distribution(i,:) = mean(F);
    S_2_sd(i,:) = std(F)/sqrt(Npath);
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
s2_marginal_mat_name = sprintf('%s/S2_marginal_density_%s_Kbin%d_binwidth%3.2f.mat',OutputFolderPath,datestr(now,'yyyy-mm-dd HH-MM-SS'),K_bin_size,binwidth);
save(s2_marginal_mat_name,'S_2_distribution','S_2_sd');
s2_marginal_csv_name = sprintf('%s/S2_marginal_density_%s_Kbin%d_binwidth%3.2f.csv',OutputFolderPath,datestr(now,'yyyy-mm-dd HH-MM-SS'),K_bin_size,binwidth);
csvwrite(s2_marginal_csv_name,S_2_distribution);
fID = fopen(sprintf('%s/S2_digital_marginal_put_report_%s.txt',OutputFolderPath,datestr(now,'yyyy-mm-dd HH-MM-SS')),'wt');
parameters_array = {'Time to Mature(Yrs)','Number of Samples'...
    ,'localvol_2','S0_2','u0_2','rhox_2u_2'; T,N,sigma0_2,S0_2,u0_2,rhox_2u_2};
para_string = sprintf('%s:%3.2f;\n',parameters_array{:});
fprintf(fID,para_string);
output_array = {'Time consumed is','Number of path simulated is';time,Npath};
string = sprintf('%s:%d;\n',output_array{:});
fprintf(fID,string);
fclose(fID);
end
