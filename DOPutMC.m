function[P,CI,NCrossed] = DOPutMC(S0,K,r,T,sigma,SBarrier,NSteps,NRepl)
[Call,put] = blsprice(S0,K,r,T,sigma);
Payoff = zeros(NRepl,1);
NCrossed = 0;
for i =1:NRepl
    Path = AssetPaths(S0,r,sigma,T,NSteps,1);
    crossed = any(Path<=SBarrier);
    if crossed == 0
        Payoff(i) = max(0, K - Path(NSteps+1));
    else
        Payoff(i) = 0;
        NCrossed = NCrossed + 1;
    end
end
[P,aux,CI] = normfit(exp(-r*T) * Payoff);
end

