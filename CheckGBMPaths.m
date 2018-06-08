function PercErrors = CheckGBMPaths(S0,mu,sigma,T,Paths)
[NRepl, NTimes] = size(Paths);
NSteps = NTimes - 1;
T_vector = (1:NSteps).*T/NSteps;
SampleMean = mean(Paths(:,2:NTimes));
TrueMean = S0*exp(mu*T_vector);
RelError_Mean = abs((SampleMean - TrueMean)./TrueMean);
SampleVar = var(Paths(:,2:(1+NSteps)));
TrueVar = S0^2 * exp(2*mu*T_vector) .* (exp((sigma^2)*T_vector)-1);
RelError_Var = abs((SampleVar - TrueVar)./TrueVar);
PercErrors = 100*[RelError_Mean',RelError_Var'];
end
