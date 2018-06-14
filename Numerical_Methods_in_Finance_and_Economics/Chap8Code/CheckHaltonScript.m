rng(3124);
NRepl = 10000;
T = 5;
NSteps = 16;
Limit = NSteps;
S0 = 50;
mu = 0.1;
sigma = 0.4;
%%
%Remark: CI are constructed with assumption on the distribution that data
%follows. Different distribution assumption results in the selection and
%comparison of different statistic/estimators, depending on the
%goal(Minimal weighted bias and variance, unbiasedness, etc.)
Paths_1 = AssetPaths(S0,mu,sigma,T,NSteps,NRepl);
PercErrors_1 = CheckGBMPaths(S0,mu,sigma,T,Paths_1);
%%
Paths_2 = HaltonPaths(S0,mu,sigma,T,NSteps,NRepl);
PercErrors_2 = CheckGBMPaths(S0,mu,sigma,T,Paths_2);
%%
Paths_3 = GBMHaltonBridge(S0,mu,sigma,T,NSteps,NRepl,Limit);
PercErrors_3 = CheckGBMPaths(S0,mu,sigma,T,Paths_3);

results = [PercErrors_1(:,1),PercErrors_2(:,1),PercErrors_3(:,1),...
    PercErrors_1(:,2),PercErrors_2(:,2),PercErrors_3(:,2)];
