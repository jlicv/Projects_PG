S0 = 50;
K = 50;
r = 0.05;
T1 = 2/12;
T2 = 7/12;
sigma = 0.4;
NRepl1 = 100;
NRepl2 = 100;
[Call,Put] = blsprice(S0,K,r,T2,sigma);
rng(3124)
[Price,CI] = AYLIMC(S0,K,r,T1,T2,sigma,NRepl1,NRepl2);
[PriceCond,CICond] = AYLIMCCond(S0,K,r,T1,T2,sigma,NRepl1*NRepl2);
fprintf(1,'Call = %f Put = %f\n',Call,Put);
fprintf(1,'MC-> Price = %f CI = (%f, %f)\n',...,
    Price,CI(1),CI(2));
fprintf(1,'Price = %6.4f%%\n',100*(CI(2)-CI(1))/Price);
fprintf(1,'MC+Cond-> Price = %f CI = (%f, %f)\n',...,
    PriceCond,CICond(1),CICond(2));
fprintf(1,'Price = %6.4f%%\n',100*(CICond(2)-CICond(1))/PriceCond);
