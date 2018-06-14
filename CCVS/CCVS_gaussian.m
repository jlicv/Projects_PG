%By: Juncheng Li;
%Date: 2018/03/21;
%Contact: jlicv@connect.ust.hk;
%CCVS pricer implemented with Quasi Monte Carlo Method and specifications
%indicated in Section 4.
%%
T = 5;
NPath = 10000;
[S_2_marginal,~,sd] = S2_digital_marginal(T,NPath,30,0.1);
%%
[curve_S_1,time_varswap] = VarswapS_1Curve(T,NPath,0);
%%
NHalton = 100000;
dt = 1/252;
Halton_dot_Nbr = NHalton;
P_2d = haltonset(2,'skip',1);
dot_Halton = net(P_2d,Halton_dot_Nbr);
dot_halton_F_S2 = dot_Halton(:,1);
dot_halton_t = dot_Halton(:,2);
x = normrnd(0,1,NHalton,1);
y = norminv(dot_halton_F_S2,0,1);
U = 1.5;
binwidth = 0.1;
xi_1 = 0.2;
kappa_1 = 0.4;
rhov_1s_2 = 0.5;

time = T*dot_halton_t;
stepnum = int64(time/dt);
stepnum(stepnum==0) = 1;

U_rownum = int64(U/binwidth);
S_2_marginal_U = S_2_marginal(U_rownum,:);
corridor_flag = dot_halton_F_S2 < S_2_marginal_U(stepnum)';

%Plenty of dots are unnecessary to calculate. Try to screen these dots out;
time_in_corridor = time(corridor_flag);
x_in_corridor = x(corridor_flag);
y_in_corridor = y(corridor_flag);
stepnum_in_corridor = stepnum(corridor_flag);
var_S_1_t = curve_S_1(stepnum_in_corridor)';

lnalpha = xi_1^2/(4*kappa_1)*(1-exp(-2*kappa_1*time_in_corridor));

copulav_1s_2 = @(x,y,rhov_1s_2) 1/(sqrt(1-rhov_1s_2^2))*exp(0.5*(x.^2+y.^2)+(2*rhov_1s_2*x.*y-x.^2-y.^2)/(2*(1-rhov_1s_2^2)));
copula_sequence = copulav_1s_2(x_in_corridor,y_in_corridor,rhov_1s_2);
estimate_sequence = T*var_S_1_t.*exp(sqrt(lnalpha).*x_in_corridor-lnalpha).*copula_sequence;
estimate = sum(estimate_sequence)/NHalton;


%Equivalently, we might as well back out vectorized sequences;

