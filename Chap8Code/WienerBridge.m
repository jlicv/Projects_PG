function WSamples = WienerBridge(T,NSteps)
%You just generate the dots in a bisecting loop.
%TRY to find some application of Brownian Bridge.
if round(log2(NSteps)) ~= log2(NSteps)
    fprintf('ERROR in WienerBridge: NSteps must be a power of 2\n');
    return
end
NBisections = log2(NSteps);
WSamples = zeros(NSteps+1,1);
WSamples(1) = 0;
WSamples(NSteps+1) = sqrt(T)*randn;
TJump = T;
IJump = NSteps;
for k = 1:NBisections
    left = 1;
    i = IJump/2 + 1;
    right = IJump + 1;
    %Round k=1: You merely bisects 1 time,between 1 and endpoint;
    %Round k=2: You bisects twice, between 1 and midpoint, between midpoint
    %and endpoint.
    %Round k=3: You bisects four times, between 1 and (midpoint+1)/2, between
    %(midpoint+1)/2 and midpoint,between midpoint and (midpoint+endpoint)/2
    %between (midpoint+endpoint)/2 and endpoint.
    %Similar cases apply for k>3.
    for j = 1:2^(k-1)
        a = 0.5*(WSamples(left) + WSamples(right));
        b = 0.5*sqrt(TJump);
        WSamples(i) = a + b*randn;
        right = right + IJump;
        left = left + IJump;
        i = i + IJump;
    end
    IJump = IJump/2;
    TJump = TJump/2;
end
end