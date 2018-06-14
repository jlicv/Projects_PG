S0 = 50;
K = 50;
mu = 0.1;
sigma = 0.4;
r = 0.05;
T = 5/12;
NRepl = 100000;
NSteps = 16;
rng(3124);
Paths = AssetPathsV(S0,mu,sigma,T,NSteps,NRepl);
Paths_Bridge = GBMBridge(S0,mu,sigma,T,NSteps,NRepl);

tic
% SL = StopLossV(S0,K,mu,sigma,r,T,Paths);
toc
DH = DeltaHedging(S0,K,mu,sigma,r,T,Paths);
[Price_Call,Price_Put] = blsprice(S0,K,r,T,sigma,0);