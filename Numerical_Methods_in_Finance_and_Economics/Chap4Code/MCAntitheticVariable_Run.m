%%
%Example 4.11
rng(3124);
X = exp(rand(100,1));
[I,dummy,CI] = normfit(X);

%%
%Example 
U1 = rand(50,1);
U2 = 1-U1;
X = 0.5*(exp(U1)+exp(U2));
[I_1,dummy_1,CI_1] = normfit(X);
