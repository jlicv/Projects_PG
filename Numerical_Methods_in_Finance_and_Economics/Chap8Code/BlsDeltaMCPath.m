function[Delta,CI] = BlsDeltaMCPath(S0,K,r,T,sigma,NRepl)
nuT = (r-0.5*sigma^2)*T;
siT = sigma * sqrt(T);
VLogn = exp(nuT+siT*randn(NRepl,1));
SampleDelta = exp(-r*T) .* VLogn .* (S0*VLogn>K);
[Delta,dummy,CI] = normfit(SampleDelta);
end