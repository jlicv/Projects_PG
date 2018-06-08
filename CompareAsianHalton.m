rng(3124);
S0 = 50;
K = 55;
r = 0.05;
sigma = 0.4;
T = 4;
NSamples = 16;

NRepl = 500000;
aux = AsianMC(S0,K,r,T,sigma,NSamples,NRepl);
fprintf(1,'Extended MC %f\n',aux);

NRepl_1 = 10000;
aux_1 = AsianHalton(S0,K,r,T,sigma,NSamples,NRepl_1);
fprintf(1,'Halton %f\n',aux_1);
%%
NumTrial = 20;
for i = 1:NumTrial
    aux_MC(i) = AsianMC(S0,K,r,T,sigma,NSamples,NRepl);
end
fprintf(1,'MC mean %f st.dev %f\n',mean(aux_MC),sqrt(var(aux_MC)));
%%
Limit = 1;
aux_HB = zeros(NumTrial,1);
for i = 1:NumTrial
    aux_HB(i) = AsianHaltonBrdige(S0,K,r,T,sigma,NSamples,NRepl,Limit);
end
fprintf(1,'Halton Bridge (limit: %d) mean %f st.dev %f\n',...
    Limit,mean(aux_HB),sqrt(var(aux_HB)));
%%
Limit = 2;
aux_HB = zeros(NumTrial,1);
for i = 1:NumTrial
    aux_HB(i) = AsianHaltonBrdige(S0,K,r,T,sigma,NSamples,NRepl,Limit);
end
fprintf(1,'Halton Bridge (limit: %d) mean %f st.dev %f\n',...
    Limit,mean(aux_HB),sqrt(var(aux_HB)));
%%
Limit = 4;
aux_HB = zeros(NumTrial,1);
for i = 1:NumTrial
    aux_HB(i) = AsianHaltonBrdige(S0,K,r,T,sigma,NSamples,NRepl,Limit);
end
fprintf(1,'Halton Bridge (limit: %d) mean %f st.dev %f\n',...
    Limit,mean(aux_HB),sqrt(var(aux_HB)));
%%
Limit = 16;
aux_HB = zeros(NumTrial,1);
for i = 1:NumTrial
    aux_HB(i) = AsianHaltonBrdige(S0,K,r,T,sigma,NSamples,NRepl,Limit);
end
fprintf(1,'Halton Bridge (limit: %d) mean %f st.dev %f\n',...
    Limit,mean(aux_HB),sqrt(var(aux_HB)));
%Chocie of the Limit of dimension of Halton Sequence in generating the 
%Brownian Bridge shows a tradeoff between bias and variance.
% Extended MC 9.106282
% Halton 8.800511
% MC mean 9.079857 st.dev 0.016973
% Halton Bridge (limit: 1) mean 9.077655 st.dev 0.014907
% Halton Bridge (limit: 2) mean 9.076248 st.dev 0.009958
% Halton Bridge (limit: 4) mean 9.376456 st.dev 0.001347
% Halton Bridge (limit: 16) mean 9.449944 st.dev 0.000000
% 
