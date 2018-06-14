function P = GeometricAsian(S0,K,r,T,sigma,delta,NSamples)
dT = T/NSamples;
nu = r - sigma^2/2 - delta;
a = log(S0)+nu*dT + 0.5*nu*(T-dT);
b = sigma^2*dT + sigma^2*(T-dT) * (2*NSamples-1)/6/NSamples;
x = (a-log(K)+b)/sqrt(b);
P = exp(-r*T)*(exp(a+b/2)*normcdf(x) - K*normcdf(x-sqrt(b)));
end