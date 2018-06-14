NRepl = 100000;
T = 1;
NSteps = 8;
WSamples = zeros(NRepl, 1+NSteps);
for i = 1:NRepl
    WSamples(i,:) = WienerBridge(T,NSteps);
end
m = mean(WSamples(:,2:(1+NSteps)));
sdev = sqrt(var(WSamples(:,2:(1+NSteps))));
sqrt((1:NSteps).*T/NSteps);%Theoretical s.d. of the Brownian Bridge Process.

