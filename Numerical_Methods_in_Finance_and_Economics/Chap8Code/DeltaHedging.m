function P = DeltaHedging(S0,K,mu,sigma,r,T,Paths)
%Plan B: Think about the maximum delta mentioned in the Structure Products
%Lesson, it should be taken into account as well.

    [NRepl,NSteps] = size(Paths);
    NSteps = NSteps -1;
    Cost = zeros(NRepl,1);
    CashFlows = zeros(1,NSteps+1);
    dt = T/NSteps;
    DiscountFactors = exp(-r*(0:1:NSteps)*dt);
    for i = 1:NRepl
        Path = Paths(i,:);
        Position = 0;
        Deltas = blsdelta(Path(1:NSteps),K,r,T-(0:NSteps-1)*dt,sigma);
        for j = 1:NSteps
            CashFlows(j) = (Position - Deltas(j))*Path(j);
            Position = Deltas(j);
        end
        if Path(NSteps+1) > K
            %The option is exercised, get the money of strike and then
            %deliver the rest part of the stock, by buying the remaining 
            %part and delivered.
            CashFlows(NSteps+1) = K - (1-Position)*Path(NSteps+1);
        else
            %If the option is not exercised, balance the position to 0.
            CashFlows(NSteps+1) = Position*Path(NSteps+1);
        end
        Cost(i) = -CashFlows*DiscountFactors';
    end
    P = mean(Cost);
end