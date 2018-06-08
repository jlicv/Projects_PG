function[Put_DO,CI,NCrossed] = DOPutMCCond(S0,K,r,T,sigma,S_Barrier,NSteps,NRepl)
dt = T/NSteps;
[Call,Put] = blsprice(S0,K,r,T,sigma);
NCrossed = 0;
Payoff = zeros(NRepl,1);
Times = zeros(NRepl,1);
StockVals = zeros(NRepl,1);
for i = 1:NRepl
    Path = AssetPathsV(S0,r,sigma,T,NSteps,1);
    tcrossed = min(find(Path<=S_Barrier));
    if not(isempty(tcrossed))
        NCrossed = NCrossed + 1;
        Times(NCrossed) = (tcrossed-1)*dt;
        StockVals(NCrossed) = Path(tcrossed);
    end
end
if(NCrossed>0)
    [Caux, Paux] = blsprice(StockVals(1:NCrossed),K,r,T-Times(1:NCrossed),sigma);
    Payoff(1:NCrossed) = exp(-r*Times(1:NCrossed).*Paux);
end
[Put_do,aux,CI] = normfit(Put - Payoff);
end