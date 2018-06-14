%NRepl: Number of Replications, Number of Path to simulate.
%NSteps: Number of timesteps contained in each path.
function SPaths = AssetPathsV(S0,mu,sigma,T,NSteps,NRepl)
dt = T/NSteps;
nudt = (mu-0.5*sigma^2)*dt;
sidt = sigma*sqrt(dt);
Increments = nudt + sidt * randn(NRepl,NSteps);
LogPaths = cumsum([log(S0)*ones(NRepl,1),Increments],2);
SPaths = exp(LogPaths);
SPaths(:,1) = S0;
end
