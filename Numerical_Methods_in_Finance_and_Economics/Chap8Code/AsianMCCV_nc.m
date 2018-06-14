function[P,CI] = AsianMCCV_nc(S0,K,r,T,sigma,NSamples,NRepl,NPilot)
TryPath = AssetPaths(S0,r,sigma,T,NSamples,NPilot);
StockSum = sum(TryPath,2);
PP = mean(TryPath(:,2:(NSamples+1)),2);
TryPayOff = exp(-r*T)*max(0,PP-K);
MatCov = cov(StockSum,TryPayOff);
c = -MatCov(1,2) / var(StockSum);
dt = T/NSamples;
ExpSum = S0 * (1-exp((NSamples+1)*r*dt)) / (1-exp(r*dt));
ControlVars = zeros(NRepl,1);
for i = 1:NRepl
    StockPath = AssetPaths(S0,r,sigma,T,NSamples,1);
    Payoff = exp(-r*T) * max(0,mean(StockPath(2:(NSamples+1)))-K);
    ControlVars(i) = Payoff + c*(sum(StockPath) - ExpSum); 
end
[P,aux,CI] = normfit(ControlVars);
end