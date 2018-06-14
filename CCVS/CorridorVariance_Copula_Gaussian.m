%By: Juncheng Li;
%Date: 2018/03/21;
%Contact: jlicv@connect.ust.hk;
%CCVS pricer implemented with Quasi Monte Carlo Method and specifications
%indicated in Section 4. 
function[payoff_estimate,err] = CorridorVariance_Copula_Gaussian(T,U,NHalton,binwidth,rhov_1s_2,varswapS_1,S_2_distribution)
timesteps = 252*T;
dt = 1/252;
xi_1 = 0.2;
kappa_1 = 0.4;
Halton_dot_Nbr = NHalton;
P_3d = haltonset(3,'skip',1);
dot_10k_3 = net(P_3d,Halton_dot_Nbr);
%halton_F_vt = dot_10k_3(:,1);
norm_z = normrnd(0,1,Halton_dot_Nbr,1);
halton_F_S2 = dot_10k_3(:,2);
halton_t = dot_10k_3(:,3);

U_rownum = int64(U/binwidth);
S_2_distribution_U = S_2_distribution(U_rownum,:);
% 
% v_1_lognorm_sd = @(t) sqrt((xi_1^2)/(2*kappa_1)*(1-exp(-2*kappa_1*t)));%2lna_t
% v_1_lognorm_mean = @(t) (xi_1^2)/(4*kappa_1)*(exp(-2*kappa_1*t)-1);%-lna_t
copulav_1s_2 = @(x,y) 1/(sqrt(1-rhov_1s_2^2))*exp(0.5*(x^2+y^2)+(2*rhov_1s_2*x*y-x^2-y^2)/(2*(1-rhov_1s_2^2)));

v_1_values = zeros(Halton_dot_Nbr,1);
copuladensity_values = zeros(Halton_dot_Nbr,1);
payoff = zeros(Halton_dot_Nbr,1);
in_corridor_marker = zeros(Halton_dot_Nbr,1);

for i = 1:Halton_dot_Nbr
    timing = halton_t(i)*T;
    if timing < dt
        timing_step_num = 1;
    else
        timing_step_num= sum(halton_t(i)*T >= (1:timesteps)*dt) ;
    end
    var_S_1_t = varswapS_1(timing_step_num);
    in_corridor_marker(i) = halton_F_S2(i) < S_2_distribution_U(timing_step_num);
    if in_corridor_marker(i) == 0
        continue;
    elseif in_corridor_marker(i) == 1
        %In MALTAB, the logninv function's mu and sigma are the mean and
        %s.d. of the associated normal distribution.
        v_1_values(i) = logninv(halton_F_vt(i),v_1_lognorm_mean(var_S_1_t),v_1_lognorm_sd(var_S_1_t));
        %Just apply normrnd on the density function, then do the
        %expectation, that's it. 
        copuladensity_values(i) = copulav_1s_2(norminv(halton_F_vt(i),0,1),norminv(halton_F_S2(i),0,1));
        %To change the integrand from ([0,1)) to ([0,T)), one needs to
        %multiply the integration T times.
        payoff(i) = T*v_1_values(i)*var_S_1_t*exp(sqrt(2*log(a_value))*norm_z(i)-log(a_value))*copuladensity_values(i);
    end
end
payoff_estimate = mean(payoff);
err = std(payoff)/sqrt(Halton_dot_Nbr);
end
