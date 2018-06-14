function[Value,Call_std] = CallMC(T,timesteps,Npath)
%rng(1234);
r = 0.02;
sigma = 0.3;
dt = T/timesteps;
K = 100;
S0 = 100;
S = zeros(Npath,1);
V = zeros(Npath,1);
rand_asset = randn(Npath,timesteps);
for i = 1:Npath
    S(i) = S0*exp((r-0.5*sigma^2)*T+sqrt(dt)*sigma*sum(rand_asset(i,:)));
    V(i) = exp(-r*T)*max(S(i)-K,0);
end
Value = mean(V);
Call_std = sqrt(1/(Npath-1)^2*sum((V-mean(V)).^2));
fprintf('std of the calculation %d .\n',Call_std);
d1 = (log(S0/K)+(r+0.5*sigma^2)*T)/(sigma*sqrt(T));
d2 = d1 - sigma*sqrt(T);
BS_value = S0*normcdf(d1) - exp(-r*T)*K*normcdf(d2);
dist = abs(Value-BS_value);
fprintf('distance between BS and Simulated Value is %d. \n',dist);
end
