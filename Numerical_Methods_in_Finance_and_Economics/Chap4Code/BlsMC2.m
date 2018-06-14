function[Price,CI] = BlsMC2(S0,K,r,T,sigma,NRepl)
nuT = (r-0.5*sigma^2)*T;
siT = sigma*sqrt(T);
DiscPayoff = exp(-r*T)*max(0,S0*exp(nuT+siT*randn(NRepl,1))-K);
[Price,VarPrice,CI] = normfit(DiscPayoff);
end