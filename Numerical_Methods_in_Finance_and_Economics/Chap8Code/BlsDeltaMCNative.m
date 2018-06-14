function [Delta,CI] = BlsDeltaMCNative(S0,K,r,T,sigma,dS,NRepl)
nuT = (r-0.5*sigma^2)*T;
siT = sigma*sqrt(T);
Payoff1 = max(0,S0*exp(nuT+siT*randn(NRepl,1))-K);
Payoff2 = max(0,(S0+dS)*exp(nuT+siT*randn(NRepl,1))-K);
SampleDiff = exp(-r*T)*(Payoff2 - Payoff1)/dS;
[Delta,dummy,CI]  = normfit(SampleDiff);
end