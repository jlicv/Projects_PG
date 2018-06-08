S0 = 50;
K = 52;
r = 0.05;
T = 5/12;
sigma = 0.4;

blsdelta(S0,K,r,T,sigma);
%%
rng(7123);
NRepl = 50000;
dS = 0.5;
[Delta,CI] = BlsDeltaMCNative(S0,K,r,T,sigma,dS,NRepl);
%With Central Difference Scheme and Common Random Numbers;
%Smaller variance and smaller bias.
[Delta_2,CI_2] = BlsDeltaMC(S0,K,r,T,sigma,dS,NRepl);
[Delta_3,CI_3] = BlsDeltaMCPath(S0,K,r,T,sigma,NRepl);