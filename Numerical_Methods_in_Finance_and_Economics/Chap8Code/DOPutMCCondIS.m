function[Put_Down_Out,CI,NCrossed] = DOPutMCCondIS(S0,K,r,T,sigma,S_Barrier,NSteps,NRepl,percent)
dt = T/NSteps;
nudt = (r-0.5*sigma^2)*dt;
b = percent*nudt;
sidt = sigma*sqrt(dt);
[Call,Put] = blsprice(S0,K,r,T,sigma);

NCrossed = 0;
Payoff = zeros(NRepl,1);
Times = zeros(NRepl,1);
StockVals = zeros(NRepl,1);
ISRatio = zeros(NRepl,1);
for i = 1:NRepl
    vetZ = nudt - b + sidt*randn(1,NSteps);
    LogPath = cumsum([log(S0),vetZ]);
    Path = exp(LogPath);
    jcrossed = min(find(Path<=S_Barrier));
    if not(isempty(jcrossed))
        NCrossed = NCrossed + 1;
        TBreach = jcrossed - 1;
        Times(NCrossed) = TBreach*dt;
        StockVals(NCrossed) = Path(jcrossed);
        ISRatio(NCrossed) = exp(TBreach*b^2/2/sigma^2/dt+...
            b/sigma^2/dt*sum(vetZ(1:TBreach)) -...
            TBreach*b/sigma^2*(r-sigma^2/2));
    end
end
if(NCrossed > 0)
    [Caux,Paux] = blsprice(StockVals(1:NCrossed),K,r,T-Times(1:NCrossed),sigma);
    Payoff(1:NCrossed) = exp(-r*Times(1:NCrossed)).*Paux.*ISRatio(1:NCrossed);
end
[Put_Down_Out,aux,CI] = normfit(Put-Payoff);
end