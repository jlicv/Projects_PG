rng(3124);
S0 = 50;
K = 55;
r = 0.05;
sigma = 0.4;
T = 1;
NSamples = 12;
NRepl = 9000;
NPilot = 1000;
%%
AsianHalton(50,50,0.1,5/12,0.4,5,1000);
%%
[P1,CI1] = AsianMC(S0,K,r,T,sigma,NSamples,NRepl+NPilot);
[P2,CI2] = AsianMCCV(S0,K,r,T,sigma,NSamples,NRepl,NPilot);
%%
[P2_nc,CI2_nc] = AsianMCCV_nc(S0,K,r,T,sigma,NSamples,NRepl,NPilot);
[P3,CI3] = AsianMCGeoCV(S0,K,r,T,sigma,NSamples,NRepl,NPilot);