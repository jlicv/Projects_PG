function WSamples = WienerHaltonBridge(T,NSteps,NRepl,Limit)
NBisections = log2(NSteps);
if round(NBisections) ~= NBisections
    fprintf('ERROR in WienerHB: NSteps must be a power of 2\n');
    return
end
% Now that GetHalton is not available, try to get the complete set instead.

% Bases = myprimes(NSteps);
% for i = 1:NSteps
%     H = GetHalton(NRepl,Bases(i));
%     RandMat(:,1) = norminv(H);
% end
P_Set = haltonset(NSteps,'skip',1);
H = net(P_Set,NRepl);
NormMat = norminv(H);

WSamples = zeros(NRepl,NSteps+1);
WSamples(:,1) = 0;
WSamples(:,NSteps+1) = sqrt(T)*NormMat(:,1);

HUse = 2;
TJump = T;
IJump = NSteps;
for k = 1:NBisections
    left = 1;
    i = IJump/2 + 1;
    right = IJump + 1;
    for j = 1:2^(k-1)
        a = 0.5*(WSamples(:,left) + WSamples(:,right));
        b = 0.5*sqrt(TJump);
        if HUse <= Limit
            WSamples(:,i) = a + b*NormMat(:,HUse);
        else
            WSamples(:,i) = a + b*randn(NRepl,1);
        end
        right = right + IJump;
        left = left + IJump;
        i = i + IJump;
    end
    IJump = IJump/2;
    TJump = TJump/2;
    HUse = HUse + 1;
end
end

