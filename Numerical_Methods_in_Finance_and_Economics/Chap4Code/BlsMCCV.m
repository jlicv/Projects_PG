function[Price,CI] = BlsMCCV(S0,K,r,T,sigma,NRepl,NPilot)
nuT = (r-0.5*sigma^2)*T;
siT = sigma*sqrt(T);
StockVals = S0*exp(nuT+siT*randn(NPilot,1));
OptionVals = exp(-r*T)*max(0,StockVals-K);
MatCov = cov(StockVals,OptionVals);
%From the fact that Y follows a log normal distribution with mean rT and
%variance sigma*sqrt(T);
VarY = S0^2 * exp(2*r*T) * (exp(T*sigma^2)-1);
%Alternatively, you may estimate variance of StockVals 
c = -MatCov(1,2)/VarY;
%log(S) follows a normal distribution with mean:S0*(r-sigma^2/2)*T, variance:
%sigma^2*T, then S follows log normal distribution with
%mean:(r-sigma^2/2+sigma^2/2)*T*S0, variance S0^2*(exp(sigma^2*T)-1)*exp(2r*T)

%An easier way to understand it is by decomposing the expectation into sum of
%increments, then apply the property of linear additivity with the fact
%that EdW_t = 0;
%Source: Wikipedia's table of Log-normal distribution.
ExpY = S0 * exp(r*T); %WHY?
NewStockVals = S0*exp(nuT+siT*randn(NRepl,1));
NewOptionVals = exp(-r*T) *max(0,NewStockVals-K);

%With same Amt. of path, a narrower CI, OR,
%With same width of CI, fewer paths to replicate.
ControlVals = NewOptionVals + c*(NewStockVals - ExpY);
[Price,VarPrice,CI] = normfit(ControlVals);
end