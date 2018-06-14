function[P,CI] = MCAVButterfly(S0,r,T,sigma,NRepl,K1,K2,K3)
nuT = (r-0.5*sigma^2)*T;
siT = sigma*sqrt(T);
Veps = randn(NRepl,1);
Stocks1 = S0*exp(nuT + siT*Veps);
Stocks2 = S0*exp(nuT - siT*Veps);

In1 = logical((Stocks1>K1) .* (Stocks1<K2));
In2 = logical((Stocks1>=K2) .* (Stocks1<K3));
Payoff1 = exp(-r*T)*[(Stocks1(In1)-K1);(K3-Stocks1(In2));...
    zeros(NRepl-sum(In1)-sum(In2),1)];
In3 = logical((Stocks2>K1) .* (Stocks2<K2));
In4 = logical((Stocks2>=K2) .* (Stocks2<K3));
Payoff2 = exp(-r*T)*[(Stocks2(In3)-K1);(K3-Stocks2(In4));...
    zeros(NRepl-sum(In3)-sum(In4),1)];
Payoff = 0.5*(Payoff1+Payoff2);
[P,V,CI] = normfit(Payoff);
end
