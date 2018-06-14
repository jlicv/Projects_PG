%By: Juncheng Li;
%Date: 2018/04/22;
%Contact: jlicv@connect.ust.hk;
%CCVS pricer implemented in Monte Carlo approach. Model spefications are
%listed in section 2 of the CCVS document.
%Remark: Without loss of generality, comments are referring to the code line right beneath;

function[var_estimate,err,time] = CorrdiorVariance_QLV(T,U,Npath,rhox_1x_2,rhou_1u_2,rhou_1x_2,rhou_2x_1,rhox_1u_1,rhox_2u_2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part0: Initialization-------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
rng(20180422);
kappa_1 = 0.4;
kappa_2 = 0.4;
xi_1 = 0.2;
xi_2 = 0.2;
u0_1 = 0;
u0_2 = 0;
% K = 0.3;
timesteps = 252*(T/1);
N = timesteps;
dt = T/timesteps;
S0_1 = 1;
S0_2 = 1;
m = 0.5;
sigma0_1 = 0.2;
sigma0_2 = 0.2;

sigma = [1 rhox_1x_2 rhox_1u_1 rhou_2x_1;rhox_1x_2 1 rhou_1x_2 rhox_2u_2;...
    rhox_1u_1 rhou_1x_2 1 rhou_1u_2; rhou_2x_1 rhox_2u_2 rhou_1u_2 1];
F = chol(sigma)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Part1: Diffusion Simulation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gx_1 = randn(Npath,timesteps);
gx_2 = randn(Npath,timesteps);
gu_1 = randn(Npath,timesteps);
gu_2 = randn(Npath,timesteps);


dWx_1 = F(1,1) * gx_1 + F(1,2) * gx_2 + F(1,3)*gu_1 + F(1,4)*gu_2;
dWx_2 = F(2,1) * gx_1 + F(2,2) * gx_2 + F(2,3)*gu_1 + F(2,4)*gu_2;
dWu_1 = F(3,1) * gx_1 + F(3,2) * gx_2 + F(3,3)*gu_1 + F(3,4)*gu_2;
dWu_2 = F(4,1) * gx_1 + F(4,2) * gx_2 + F(4,3)*gu_1 + F(4,4)*gu_2;

u_1 = zeros(Npath,timesteps+1);
v_1 = ones(Npath,timesteps+1);
u_1(:,1) = u0_1;
v_1(:,1) = 1;

u_2 = zeros(Npath,timesteps+1);
v_2 = ones(Npath,timesteps+1);
u_2(:,1) = u0_2;
v_2(:,1) = 1;

dx_1 = zeros(Npath,timesteps);
dx_2 = zeros(Npath,timesteps);
S_1 = zeros(Npath,timesteps+1);
S_2 = zeros(Npath,timesteps);
S_1(:,1) = S0_1;
S_2(:,1) = S0_2;

for i = 1:timesteps
    du_1 = -kappa_1*u_1(:,i)*dt + xi_1*sqrt(dt)*dWu_1(:,i);
    u_1(:,i+1) = u_1(:,i) + du_1;
    v_1(:,i+1) = exp(u_1(:,i+1)-xi_1^2/(4*kappa_1)*(1-exp(-2*kappa_1*(i+1)*dt)));
    du_2 = -kappa_2*u_2(:,i)*dt + xi_2*sqrt(dt)*dWu_2(:,i);
    u_2(:,i+1) = u_2(:,i) + du_2;
    v_2(:,i+1) = exp(u_2(:,i+1)-xi_2^2/(4*kappa_2)*(1-exp(-2*kappa_2*(i+1)*dt)));
end

for i = 1:timesteps
    sigma_lv = sigma0_1*(m*S_1(:,i)+1);
    dx_1(:,i) = -0.5*sigma_lv.^2.*v_1(:,i)*dt + sqrt(dt.*v_1(:,i)).*sigma_lv.*dWx_1(:,i);
    S_1(:,i+1) = S_1(:,i).*exp(dx_1(:,i));
    
end
for i = 1:timesteps-1
    sigma_lv = sigma0_2*(m*S_2(:,i)+1);
    dx_2(:,i) = -0.5*sigma_lv.^2.*v_2(:,i)*dt + sqrt(dt.*v_2(:,i)).*sigma_lv.*dWx_2(:,i);
    S_2(:,i+1) = S_2(:,i).*exp(dx_2(:,i));
end

% Annotated pieces for below 10 lines are for diagnosis convenicence 
% for i = 1:timesteps
%     sigma_lv = sigma0_1*(m*S_1(:,i)+1);
%     dx_1(:,i) = -0.5*sigma_lv.^2*dt + sqrt(dt)*sigma_lv.*dWx_1(:,i);
%     S_1(:,i+1) = S_1(:,i).*exp(dx_1(:,i));
% end
% 
% for i = 1:timesteps-1
%     sigma_lv = sigma0_2*(m*S_2(:,i)+1);
%     dx_2(:,i) = -0.5*sigma_lv.^2*dt + sqrt(dt)*sigma_lv.*dWx_2(:,i);
%     S_2(:,i+1) = S_2(:,i).*exp(dx_2(:,i));
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part2: Payoff Calculation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w_2_inside = S_2<U;
corridorvar = 252/N*sum(dx_1.^2.*w_2_inside,2);
err = mean(corridorvar)/sqrt(Npath);
var_estimate = mean(corridorvar);

% Annotated pieces for below 15 lines are for diagnosis convenicence 
% figure;
% hold on;
% for i = [1:3:15,50]
%     U = 0.5+i*0.1;
%     w_2_inside = S_2<U;
%     rlzd_var = 252*cumsum(sum(dx_1.^2.*w_2_inside,1)/Npath)./(1:timesteps);
%     plot(rlzd_var);
% end
% xlabel('Days')
% ylabel('Annualized Rlzd. Var.')
% title('Realized Var.,QNV-SV,T=10yrs')
% legend('U=0.6','U=1.0','U=1.2','U=1.5','U=1.8','U=5.5')
% hold off;
% rlzd_var = 252*cumsum(sum(dx_1.^2.*w_2_inside,1)/Npath)./(1:timesteps);
% pi_estimate = rlzd_var;
time = toc;
end
