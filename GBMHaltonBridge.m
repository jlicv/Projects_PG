function Paths = GBMHaltonBridge(S0,mu,sigma,T,NSteps,NRepl,Limit)
if round(log2(NSteps)) ~= log2(NSteps)
    fprintf('ERROR in GBMBridge: NSteps must be a power of 2\n');
    return
end
dt = T/NSteps;
nudt = (mu-0.5*sigma^2)*dt;
W = WienerHaltonBridge(T,NSteps,NRepl,Limit);
Increments = nudt + sigma*diff(W,1,2);
LogPath = cumsum([log(S0)*ones(NRepl,1), Increments],2);
Paths = exp(LogPath);
Paths(:,1) = S0;
end