%By: Juncheng Li;
%Date: 2018/03/21;
%Contact: jlicv@connect.ust.hk;
%%
rng(7124);
Ndot = 100000;
%x:u
%y:v
x = normrnd(0,1,Ndot,1);
y = normrnd(0,1,Ndot,1);
%%
C_pu_pv = @(x,y,rhov_1s_2) 1/(sqrt(1-rhov_1s_2^2))*exp(0.5*(x.^2+y.^2)+(2*rhov_1s_2*x.*y-x.^2-y.^2)/(2*(1-rhov_1s_2^2)));
C_pu = @(x,y,rhov_1s_2) normcdf((y-rhov_1s_2*x)/sqrt(1-rhov_1s_2^2));
C_pv = @(x,y,rhov_1s_2) normcdf((x-rhov_1s_2*y)/sqrt(1-rhov_1s_2^2));
%The normpdf term at the denominator may account for instability of estimation;
C_pu_pu = @(x,y,rhov_1s_2) (-rhov_1s_2/sqrt(1-rhov_1s_2^2))*normpdf((y-rhov_1s_2*x)/sqrt(1-rhov_1s_2^2)).*(1./normpdf(x));
C_pv_pv = @(x,y,rhov_1s_2) (-rhov_1s_2/sqrt(1-rhov_1s_2^2))*normpdf((x-rhov_1s_2*y)/sqrt(1-rhov_1s_2^2)).*(1./normpdf(y));

C_pu_prho = @(x,y,rhov_1s_2) normpdf((y-rhov_1s_2*x)/sqrt(1-rhov_1s_2^2)).*(-1/((1-rhov_1s_2^2)^(1.5))*x);
C_pv_prho = @(x,y,rhov_1s_2) normpdf((x-rhov_1s_2*y)/sqrt(1-rhov_1s_2^2)).*(-1/((1-rhov_1s_2^2)^(1.5))*y);

rhov_1s_2_sequence = -0.99:0.01:0.99;
table_rhov_1s_2_sequence = table(rhov_1s_2_sequence','VariableNames',{'rhov_1s_2'});
%%
C_pu_estimate = @(rho) mean(C_pu(x,y,rho));
C_pu_sequence = rowfun(C_pu_estimate,table_rhov_1s_2_sequence,'OutputVariableNames','pu');

C_pv_estimate = @(rho) mean(C_pv(x,y,rho));
C_pv_sequence = rowfun(C_pv_estimate,table_rhov_1s_2_sequence,'OutputVariableNames','pv');

C_pu_pv_estimate = @(rho) mean(C_pu_pv(x,y,rho));
C_pu_pv_sequence = rowfun(C_pu_pv_estimate,table_rhov_1s_2_sequence,'OutputVariableNames','pupv');

C_pu_pu_estimate = @(rho) mean(C_pu_pu(x,y,rho));
C_pu_pu_sequence = rowfun(C_pu_pu_estimate,table_rhov_1s_2_sequence,'OutputVariableNames','pupu');

C_pv_pv_estimate = @(rho) mean(C_pv_pv(x,y,rho));
C_pv_pv_sequence = rowfun(C_pv_pv_estimate,table_rhov_1s_2_sequence,'OutputVariableNames','pvpv');

C_pu_prho_estimate = @(rho) mean(C_pu_prho(x,y,rho));
C_pu_prho_sequence = rowfun(C_pu_prho_estimate,table_rhov_1s_2_sequence,'OutputVariableNames','puprho');

C_pv_prho_estimate = @(rho) mean(C_pv_prho(x,y,rho));
C_pv_prho_sequence = rowfun(C_pv_prho_estimate,table_rhov_1s_2_sequence,'OutputVariableNames','pvprho');
%%
C_pu_sd = @(rho) std((C_pu(x,y,rho)))/sqrt(Ndot);
C_pu_sd_estimate = rowfun(C_pu_sd,table_rhov_1s_2_sequence,'OutputVariableNames','pu_sd');

C_pv_sd = @(rho) std((C_pv(x,y,rho)))/sqrt(Ndot);
C_pv_sd_estimate = rowfun(C_pv_sd,table_rhov_1s_2_sequence,'OutputVariableNames','pv_sd');

C_pu_pu_sd = @(rho) std((C_pu_pu(x,y,rho)))/sqrt(Ndot);
C_pu_pu_sd_estimate = rowfun(C_pu_pu_sd,table_rhov_1s_2_sequence,'OutputVariableNames','pupu_sd');

C_pv_pv_sd = @(rho) std((C_pv_pv(x,y,rho)))/sqrt(Ndot);
C_pv_pv_sd_estimate = rowfun(C_pv_pv_sd,table_rhov_1s_2_sequence,'OutputVariableNames','pvpv_sd');

C_pu_pv_sd = @(rho) std((C_pu_pv(x,y,rho)))/sqrt(Ndot);
C_pu_pv_sd_estimate = rowfun(C_pu_pv_sd,table_rhov_1s_2_sequence,'OutputVariableNames','pupv_sd');

C_pu_prho_sd = @(rho) std((C_pu_prho(x,y,rho)))/sqrt(Ndot);
C_pu_prho_sd_estimate = rowfun(C_pu_prho_sd,table_rhov_1s_2_sequence,'OutputVariableNames','puprho_sd');

C_pv_prho_sd = @(rho) std((C_pv_prho(x,y,rho)))/sqrt(Ndot);
C_pv_prho_sd_estimate = rowfun(C_pv_prho_sd,table_rhov_1s_2_sequence,'OutputVariableNames','pvprho_sd');

%%
plot(rhov_1s_2_sequence,C_pu_sequence.pu);
hold on;
plot(rhov_1s_2_sequence,C_pv_sequence.pv);
plot(rhov_1s_2_sequence,C_pu_pv_sequence.pupv);
plot(rhov_1s_2_sequence,C_pu_pu_sequence.pupu);
plot(rhov_1s_2_sequence,C_pv_pv_sequence.pvpv);
plot(rhov_1s_2_sequence,C_pu_prho_sequence.puprho);
plot(rhov_1s_2_sequence,C_pv_prho_sequence.pvprho);
legend('pu','pv','pupv','pupu','pvpv','puprho','pvprho','Location','Best')
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, number of dot =%d',Ndot);
title(titlestring);
hold off;
%%
figure;
plot(rhov_1s_2_sequence,C_pu_sequence.pu);
hold on;
plot(rhov_1s_2_sequence,C_pv_sequence.pv);
legend('pu','pv','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, number of dot =%d',Ndot);
title(titlestring);
hold off;

figure;
plot(rhov_1s_2_sequence,C_pu_sequence.pu + 1.96*C_pu_sd_estimate.pu_sd);
hold on
plot(rhov_1s_2_sequence,C_pu_sequence.pu);
plot(rhov_1s_2_sequence,C_pu_sequence.pu - 1.96*C_pu_sd_estimate.pu_sd);
legend('pu Upper Bound','pu Estimate','pu Lower Bound','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, 95%%CI, number of dot =%d',Ndot);
title(titlestring);
hold off
%%
figure;
plot(rhov_1s_2_sequence,C_pv_sequence.pv + 1.96*C_pv_sd_estimate.pv_sd);
hold on
plot(rhov_1s_2_sequence,C_pv_sequence.pv);
plot(rhov_1s_2_sequence,C_pv_sequence.pv - 1.96*C_pv_sd_estimate.pv_sd);
legend('pv Upper Bound','pv Estimate','pv Lower Bound','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, 95%%CI, number of dot =%d',Ndot);
title(titlestring);
hold off
%%
figure;
plot(rhov_1s_2_sequence,C_pu_pu_sequence.pupu);
hold on;
plot(rhov_1s_2_sequence,C_pv_pv_sequence.pvpv);
legend('pupu','pvpv','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, number of dot =%d',Ndot);
title(titlestring);
hold off;

figure;
plot(rhov_1s_2_sequence,C_pu_prho_sequence.puprho);
hold on;
plot(rhov_1s_2_sequence,C_pv_prho_sequence.pvprho);
legend('puprho','pvprho','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, number of dot =%d',Ndot);
title(titlestring);
hold off;
%%
%Seems bearable in the size of variation
figure;
plot(rhov_1s_2_sequence,C_pu_prho_sequence.puprho + 1.96*C_pu_prho_sd_estimate.puprho_sd);
hold on
plot(rhov_1s_2_sequence,C_pu_prho_sequence.puprho);
plot(rhov_1s_2_sequence,C_pu_prho_sequence.puprho - 1.96*C_pu_prho_sd_estimate.puprho_sd);
legend('puprho Upper Bound','puprho Estimate','puprho Lower Bound','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, 95%%CI, number of dot =%d',Ndot);
title(titlestring);
hold off

figure;
plot(rhov_1s_2_sequence,C_pv_prho_sequence.pvprho + 1.96*C_pv_prho_sd_estimate.pvprho_sd);
hold on
plot(rhov_1s_2_sequence,C_pv_prho_sequence.pvprho);
plot(rhov_1s_2_sequence,C_pv_prho_sequence.pvprho - 1.96*C_pv_prho_sd_estimate.pvprho_sd);
legend('pvprho Upper Bound','pvprho Estimate','pvprho Lower Bound','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, 95%%CI, number of dot =%d',Ndot);
title(titlestring);
hold off
%%
%pupu&pvpv confidence interval
figure;
plot(rhov_1s_2_sequence,C_pu_pu_sequence.pupu + 1.96*C_pu_pu_sd_estimate.pupu_sd);
hold on
plot(rhov_1s_2_sequence,C_pu_pu_sequence.pupu);
plot(rhov_1s_2_sequence,C_pu_pu_sequence.pupu - 1.96*C_pu_pu_sd_estimate.pupu_sd);
legend('pupu Upper Bound','pupu Estimate','pupu Lower Bound','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, 95%%CI, number of dot =%d',Ndot);
title(titlestring);
hold off

figure;
plot(rhov_1s_2_sequence,C_pv_pv_sequence.pvpv + 1.96*C_pv_pv_sd_estimate.pvpv_sd);
hold on
plot(rhov_1s_2_sequence,C_pv_pv_sequence.pvpv);
plot(rhov_1s_2_sequence,C_pv_pv_sequence.pvpv - 1.96*C_pv_pv_sd_estimate.pvpv_sd);
legend('pvpv Upper Bound','pvpv Estimate','pvpv Lower Bound','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, 95%%CI, number of dot =%d',Ndot);
title(titlestring);
hold off
%%
figure;
plot(rhov_1s_2_sequence,C_pu_pv_sequence.pupv);
legend('pupv','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, number of dot =%d',Ndot);
title(titlestring);

figure;
plot(rhov_1s_2_sequence,C_pu_pv_sequence.pupv + 1.96*C_pu_pv_sd_estimate.pupv_sd);
hold on
plot(rhov_1s_2_sequence,C_pu_pv_sequence.pupv);
plot(rhov_1s_2_sequence,C_pu_pv_sequence.pupv - 1.96*C_pu_pv_sd_estimate.pupv_sd);
legend('pupv Upper Bound','pupv Estimate','pupv Lower Bound','Location','Best');
xlabel('rhov_1s_2');
ylabel('value');
titlestring = sprintf('Sensitivity of partial derivative against rho, 95%%CI, number of dot =%d',Ndot);
title(titlestring);
hold off


