function[P,CI] = AsianMCGeoCV(S0,K,r,T,sigma,NSamples,NRepl,NPilot)
DF = exp(-r*T);
GeoExact = GeometricAsian(S0,K,r,T,sigma,0,NSamples);
GeoPrices = zeros(NPilot,1);
AriPrices = zeros(NPilot,1);
for i = 1:NPilot
    Path = AssetPaths(S0,r,sigma,T,NSamples,1);
    GeoPrices(i) = DF*max(0,(prod(Path(2:(NSamples+1))))^(1/NSamples) - K);
    AriPrices(i) = DF*max(0,mean(Path(2:(NSamples+1))) - K);
end
MatCov = cov(GeoPrices,AriPrices);
c = -MatCov(1,2)/var(GeoPrices);
ControlVars = zeros(NRepl,1);
for i = 1:NRepl
    Path = AssetPaths(S0,r,sigma,T,NSamples,1);
    GeoPrice = DF*max(0,(prod(Path(2:(NSamples+1))))^(1/NSamples) - K);
    AriPrice = DF*max(0,mean(Path(2:(NSamples+1))) - K);
    ControlVars(i) = AriPrice + c*(GeoPrice - GeoExact);
end
[P,aux,CI] = normfit(ControlVars);
end