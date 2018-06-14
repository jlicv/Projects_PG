function SPaths = HaltonPaths(S0,mu,sigma,T,NSteps,NRepl)
%Remark: NSteps and NSamples are the same, referring to timesteps requried
%for the simulation process.
dt = T/NSteps;
nudt = (mu-0.5*sigma^2)*dt;
sidt = sigma*sqrt(dt);

NormMat = zeros(NRepl,NSteps);
% Now that GetHalton is not available, try to get the complete set instead.

% Bases = myprimes(NSteps);
% for i = 1:NSteps
%     H = GetHalton(NRepl,Bases(i));
%     RandMat(:,1) = norminv(H);
% end
P_Set = haltonset(NSteps,'skip',1);
H = net(P_Set,NRepl);
RandMat = norminv(H);
Increments = nudt + sidt*RandMat;
LogPaths = cumsum([log(S0)*ones(NRepl,1), Increments],2);
SPaths = exp(LogPaths);
SPaths(:,1) = S0;

end

function p =myprimes(N)
found = 0;
trynumber = 2;
p = [];
while(found<N)
    if isprime(trynumber)
        p = [p,trynumber];
        found = found + 1;
    end
    trynumber = trynumber + 1;
end
end