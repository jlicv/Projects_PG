function [Delta,CI] = BlsDeltaMC(S0,K,r,T,sigma,dS,NRepl)
nuT = (r-0.5*sigma^2)*T;
siT = sigma*sqrt(T);
RndMat = randn(NRepl,1);
Payoff1 = max(0,(S0-dS)*exp(nuT+siT*RndMat)-K);
Payoff2 = max(0,(S0+dS)*exp(nuT+siT*RndMat)-K);
SampleDiff = exp(-r*T)*(Payoff2 - Payoff1)/(2*dS);
[Delta,dummy,CI]  = normfit(SampleDiff);
end