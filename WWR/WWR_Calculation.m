rng(1234);
% WWR_10k = zeros(10,1);
% err_10k = zeros(10,1);
% time_10k = zeros(10,1);
% for i = 1:10
%     [WWR_10k(i),err_10k(i),time_10k(i)] = WWR(1,i*100,10000);
% end
% timesteps = 100:100:1000;
% plot(timesteps,time_10k);
% xlabel('Timesteps');
% ylabel('Runtime');
% plot(timesteps,WWR_10k);
% xlabel('Timesteps');
% ylabel('W.W.R.');
% plot(timesteps,err_10k);
% xlabel('Timesteps');
% ylabel('S.D. of W.W.R. Estimate');

path = [10000,100000,500000,1000000];
WWR_error = zeros(length(path),1);
WWR_estimate = zeros(length(path),1);
WWR_time = zeros(length(path),1);
for i = 1:length(path)
    [WWR_estimate(i),WWR_error(i),WWR_time(i)] = WWR(1,500,path(i));
end

% Strike = (90:1:110);
% J = (0.1:0.1:0.9);
% [X,Y] = meshgrid(J,Strike);
% WWR_record = zeros(length(Strike),length(J));
% WWRSD_record = zeros(length(Strike),length(J));
% Runtime_record = zeros(length(Strike),length(J));
% for i = 1:length(Strike)
%     for j = 1:length(J)
%         [WWR_record(i,j),WWRSD_record(i,j),Runtime_record(i,j)]=WWR_Strike_Jump(1,500,10000,Strike(i),J(j));
%     end
% end
% surf(X,Y,WWR_record);
% xlabel('Proportion of Jump');
% ylabel('Strike Price of Call Option');
% zlabel('Wrong Way Risk Estimation');

% sigma = (0.1:0.1:0.9);
% lambda_zero = (0.01:0.02:0.21);
% [X,Y] = meshgrid(lambda_zero,sigma);
% WWR_record = zeros(length(lambda_zero),length(sigma));
% WWRSD_record = zeros(length(lambda_zero),length(sigma));
% Runtime_record = zeros(length(lambda_zero),length(sigma));
% for i = 1:length(lambda_zero)
%     for j = 1:length(sigma)
%         [WWR_record(i,j),WWRSD_record(i,j),Runtime_record(i,j)]=WWR_sigma_lambda(1,500,10000,sigma(j),lambda_zero(i));
%     end
% end
% surf(X,Y,WWR_record');
% xlabel('Initial Default Intensity');
% ylabel('Annualized Volatility of S');
% zlabel('Wrong Way Risk Estimation');
% surf(X,Y,WWRSD_record');
% xlabel('Initial Default Intensity');
% ylabel('Annualized Volatility of S');
% zlabel('Estimated Standard Deviation of the W.W.R. Estimate');
% 
% r = (0.01:0.01:0.10);
% T = (1:1:10);
% [X,Y] = meshgrid(r,T);
% WWR_record = zeros(length(r),length(T));
% WWRSD_record = zeros(length(r),length(T));
% Runtime_record = zeros(length(r),length(T));
% for i = 1:length(r)
%     for j = 1:length(T)
%         [WWR_record(i,j),WWRSD_record(i,j),Runtime_record(i,j)]=WWR_r_T(r(i),T(j),500*T(j),10000);
%     end
% end
% surf(X,Y,WWR_record');
% xlabel('Annualized Risk-free Rate');
% ylabel('Time to maturity');
% zlabel('Wrong Way Risk Estimation');
% surf(X,Y,WWRSD_record');
% xlabel('Annualized Risk-free Rate');
% ylabel('Time to maturity');
% zlabel('Estimated Standard Deviation of the W.W.R. Estimate');

% 
% 
% theta = (0.01:0.01:0.09);
% vu = (0.5:0.2:2.3);
% [X,Y] = meshgrid(theta,vu);
% WWR_record = zeros(length(theta),length(vu));
% WWRSD_record = zeros(length(theta),length(vu));
% Runtime_record = zeros(length(theta),length(vu));
% for i = 1:length(theta)
%     for j = 1:length(vu)
%         [WWR_record(i,j),WWRSD_record(i,j),Runtime_record(i,j)]=WWR_theta_vu(1,500,10000,theta(i),vu(j));
%     end
% end
% surf(X,Y,WWR_record');
% xlabel('Theta');
% ylabel('Vu');
% zlabel('Wrong Way Risk Estimation');
% surf(X,Y,WWRSD_record');
% xlabel('Theta');
% ylabel('Vu');
% zlabel('Estimated Standard Deviation of the W.W.R. Estimate');
% 
