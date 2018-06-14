function[Price,CI] = AYLIMC(S0,K,r,T1,T2,sigma,NRepl1,NRepl2)
DeltaT = T2-T1;
muT1 = (r-sigma^2/2)*T1;
muT2 = (r-sigma^2/2)*(T2-T1);
siT1 = sigma*sqrt(T1);
siT2 = sigma*sqrt(T2-T1);
DiscountedPayoffs = zeros(NRepl1*NRepl2,1);

Samples1 = randn(NRepl1,1);
PriceT1 = S0*exp(muT1 + siT1*Samples1);
for k = 1:NRepl1
    Samples2 = randn(NRepl2,1);
    PriceT2 = PriceT1(k)*exp(muT2 + siT2*Samples2);
    ValueCall = exp(-r*DeltaT)*mean(max(PriceT2 - K,0));
    ValuePut = exp(-r*DeltaT)*mean(max(K - PriceT2,0));
    if ValueCall > ValuePut
        DiscountedPayoffs(1+(k-1)*NRepl2:k*NRepl2) = ...
            exp(-r*T2)*max(PriceT2 - K,0);
    else
        DiscountedPayoffs(1+(k-1)*NRepl2:k*NRepl2) = ...
            exp(-r*T2)*max(K - PriceT2,0);
    end
end

[Price,dummy,CI] = normfit(DiscountedPayoffs);
end