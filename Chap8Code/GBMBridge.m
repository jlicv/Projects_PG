function SPaths = GBMBridge(S0, mu, sigma, T, NSteps, NRepl)
if round(log2(NSteps)) ~= log2(NSteps)
    fprintf('ERROR in GBMBridge: NSteps must be a power of 2\n');
    return
end
dt = T/NSteps;
nudt = (mu-0.5*sigma^2)*dt;
SPaths = zeros(NRepl,NSteps+1);
for k = 1:NRepl
    W = WienerBridge(T,NSteps);
    Log_Increments = nudt + sigma*diff(W');
%     LogPath = cumsum([log(S0), Increments]);
%     SPaths(k,:) = exp(LogPath);
    SPaths(k,:) = S0*cumprod([1, exp(Log_Increments)]);
end
end