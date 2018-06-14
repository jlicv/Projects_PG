function SPaths = AssetPaths(S0,mu,sigma,T,NSteps,NRepl)
SPaths = zeros(NRepl,1+NSteps);
SPaths(:,1) = S0;
dt = T/NSteps;
nudt = (mu-0.5*sigma^2)*dt;
sidt = sigma*sqrt(dt);
for i = 1:NRepl
    for j = 1:NSteps
        SPaths(i,j+1) = SPaths(i,j)*exp(nudt+sidt*randn);
    end
end
end