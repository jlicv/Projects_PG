%Description: Stop Loss Strategy for European Call Vanilla Option.
%Further improvement may change S0,K,mu,sigma,r,T into a struct named
%Contract.
function P = StopLossV(S0,K,mu,sigma,r,T,Paths)
[NRepl,NSteps] = size(Paths);
NSteps = NSteps-1; %Timing points between 1:FinalTimePoint-1, s.t. a lagged equity price matrix can be created.
CashFlows = zeros(NRepl,NSteps+1);
dt = T/NSteps;
DiscountFactors = exp(-r*(0:1:NSteps)*dt);
OldPrice = [zeros(NRepl,1),Paths(:,1:NSteps)];
UpTimes = find(OldPrice < K & Paths >= K);
DownTimes = find(OldPrice >= K & Paths<K);
CashFlows(UpTimes) = -Paths(UpTimes);
CashFlows(DownTimes) = Paths(DownTimes);
%When option is in not OTM, underwriter of option needs to sell the equity.
%to the holder at a predetermined strike, such action gives a cash flow of
%K dollars.

%By setting first column of OldPrice equal to zero, every time you start
%the path, you have to spend S0 to buy the stock, avoding the possibility
%of naked short.
ExPaths = find(Paths(:,NSteps+1)>=K);
CashFlows(ExPaths,NSteps+1) = CashFlows(ExPaths,NSteps+1) + K;
Cost = -CashFlows*DiscountFactors';
P = mean(Cost);
end

