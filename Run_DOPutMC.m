[P,CI,NCrossed] = DOPutMC(50,50,0.1,2/12,0.4,40,60,50000);
%%
P_Analytic = DOPut(50,50,0.1,2/12,0.4,40*exp(-0.5826*0.4*sqrt(1/12/30)));
%%
[P_IS,CI_IS,NCrossed_IS] = DOPutMCCondIS(50,52,0.1,2/12,0.4,30,60,10000,200);
