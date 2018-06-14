function P = AsianHalton(S0,K,r,T,sigma,NSamples,NRepl)
Payoff = zeros(NRepl,1);
Path = HaltonPaths(S0,r,sigma,T,NSamples,NRepl);
Payoff = max(0,mean(Path(:,2:(NSamples+1)),2) - K);
P = mean(exp(-r*T)*Payoff);
end