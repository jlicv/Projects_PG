%GBM, Analytical results to ensure the price matches.
S0 = 60;
K1 = 55;
K2 = 60;
K3 = 65;
T = 5/12;
r = 0.1;
sigma = 0.4;
calls = blsprice(S0,[K1,K2,K3],r,T,sigma);
Price = calls(1) - 2*calls(2) + calls(3);

%%
%By Monte Carlo Approach.
%Trial to see that variance of Butterfly payoff may increase with the antithetic
%variable, when the payoff is non-monotomic w.r.t. to the strike price,i.e.
%negative correlation between antithetic var. and the original var. may be
%positive.
rng(3124);
%Crude MC
[P,CI] = MCButterfly(S0,r,T,sigma,100000,K1,K2,K3);
width_CI = (CI(2)-CI(1))/P;
%MC with Antithetic Variable.
[P_AV,CI_AV] = MCAVButterfly(S0,r,T,sigma,50000,K1,K2,K3);
width_CI_AV = (CI_AV(2) - CI_AV(1))/P_AV;

%%
NTrial = 100;
V1 = zeros(NTrial,1);
V2 = zeros(NTrial,1);
%Interestingly, for this run, on average, antithetic technique has slightly
%better performance to crude MC.
for i =100
    V1(i) = MCButterfly(S0,r,T,sigma,100000,K1,K2,K3);
    V2(i) = MCAVButterfly(S0,r,T,sigma,50000,K1,K2,K3);
end
sd_MC = sqrt(mean(V1-Price).^2);
sd_MC_AV = sqrt(mean(V2-Price).^2);

%%
%Control Variate Example 4.20
P_BS = blsprice(50,52,0.1,5/12,0.4);
[P_O,CI_O] = BlsMC2(50,52,0.1,5/12,0.4,200000);  
BandOPercentage = (CI_O(2)-CI_O(1))/P_O;
[P_CV,CI_CV] = BlsMCCV(50,52,0.1,5/12,0.4,195000,5000);
BandCVPercentage = (CI_CV(2)-CI_CV(1))/P_CV;