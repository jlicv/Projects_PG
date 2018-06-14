function[Price,CI] = AYLIMCCond(S0,K,r,T1,T2,sigma,NRepl)
muT1 = (r-sigma^2/2)*T1;
siT1 = sigma*sqrt(T1);
Samples = randn(NRepl,1);
PriceT1 = S0*exp(muT1 + siT1*Samples);
[calls,puts] = blsprice(PriceT1,K,r,T2-T1,sigma);
Values = exp(-r*T1)*max(calls,puts);
[Price,dummy,CI] = normfit(Values);
end