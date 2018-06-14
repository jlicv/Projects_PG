function[WWRisk,err1,time] = WWR_rho_J(T,timesteps,Npath,rho,J)
%To ensure the reproducibility, random seed is set at the beginning of each
%execution.
rng(1234);
tic
r = 0.02;
sigma = 0.3;
kappa = 0.05;
theta = 0.02;
vu = 1;
loss = 0.6;
K = 100;
S0 = 100;
lambda_zero = 0.02;
S = zeros(Npath,1);
V = zeros(Npath,1);
lambda = zeros(Npath,timesteps);
density = zeros(timesteps,1);
prob = zeros(timesteps,1);
tau = zeros(Npath,1);
index = zeros(Npath,1);
lambda(:,1) = lambda(:,1) + lambda_zero;
dt = T/timesteps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Part0: Density Simulation-----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function[value] = G(lambda,t,T)
        gamma = sqrt(kappa^2+2*vu^2);
        Denominator = (gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma;
        H1 = ((2*gamma*exp(0.5*(gamma+kappa)*(T-t)))/Denominator)^(2*kappa*theta/(vu^2));
        H2 = 2*((exp(gamma*(T-t))-1))/((gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma);
        value = H1*exp(-H2*lambda);
    end

    function[value] = dGbydt(lambda,t,T)
        gamma = sqrt(kappa^2+2*vu^2);
        Denominator = (gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma;
        %let tprime = T-t, by the chain rule you can get the
        %corresponding derivative;
        H1_Numerator = (2*gamma*exp(0.5*(gamma+kappa)*(T-t)));
        H2_Numerator = 2*((exp(gamma*(T-t))-1));
        H1 = (H1_Numerator/Denominator)^(2*kappa*theta/(vu^2));
        H2 = H2_Numerator/Denominator;
        dH1_dtprime = (0.5*(gamma+kappa)*2*gamma*Denominator-(gamma+kappa)*gamma*exp(gamma*(T-t))*H1_Numerator)/(Denominator^2);
        value_first = 2*kappa*theta/(vu^2)*(H1_Numerator/Denominator)^(2*kappa*theta/(vu^2)-1)*dH1_dtprime*exp(-H2*lambda);
        dH2_dtprime = (2*gamma*exp(gamma*(T-t))*Denominator-(gamma+kappa)*gamma*exp(gamma*(T-t))*H2_Numerator)/(Denominator^2);
        value_second = H1*lambda*dH2_dtprime*exp(-H2*lambda);
        value = -1*(value_first+value_second);
    end

dp_tau_t_deno = 1-G(lambda_zero,0,T);
for j = 2:timesteps
    density(j) = -dGbydt(lambda_zero,0,(j-1)*dt)/dp_tau_t_deno;
    prob(j) = prob(j-1)+density(j)*dt;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------Part1: Default Time Simulation--------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rand_tau = rand(Npath,1);
% sigma = [1 0.5:0.5 1];
% R = chol(sigma);
rand_lambda = randn(Npath,timesteps);
rand_asset = randn(Npath,timesteps);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part2: Payoff Calculation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:Npath
    if(isempty(find(rand_tau(i)<=prob,1,'first')))
        index(i) = timesteps;
        tau(i)=T;
    else
        index(i) = find(rand_tau(i)<=prob,1,'first');
        tau(i) = index(i)*dt;
    end
    payoff_1 = sum(rho*sqrt(dt)*rand_lambda(i,1:index(i)));
    payoff_2 = sum(sqrt(1-rho^2)*sqrt(dt)*rand_asset(i,1:index(i)));
    dt_term = (r-0.5*sigma^2)*tau(i);
    S(i) = S0*(1-rho*J)*exp(dt_term+sigma*(payoff_1+payoff_2));
    V(i) = exp(-r*tau(i))*(1-loss)*max(S(i)-K,0);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Part3:Intensity Calculation---------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:Npath
    for j = 2:timesteps
        lndlambda = 1/lambda(i,j-1)*(kappa*(theta-lambda(i,j-1))-0.5*vu^2)...
            *dt+vu/sqrt(lambda(i,j-1))*sqrt(dt)*rand_lambda(i,j-1);
        lambda(i,j) = exp(lndlambda)*lambda(i,j-1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------Part4: WWR Calculation------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_rho0J0 = zeros(Npath,1);
V_rho0J0 = zeros(Npath,1);
for i = 1:Npath
    S_rho0J0(i) = S0*exp((r-0.5*sigma^2)*tau(i)+...
        sum(sqrt(dt)*sigma*rand_asset(i,1:index(i))));
    V_rho0J0(i) = (1-loss)*exp(-r*tau(i))*max(S_rho0J0(i)-K,0);
end

WWRisk = mean(V) - mean(V_rho0J0);
err1 = std(V)/sqrt((Npath-1));
err2 = std(V_rho0J0)/sqrt((Npath-1));
fprintf('The WWR estimate is %d. \n',WWRisk);
fprintf('The estimated standard error of the Correlated Option Value estimate is %d. \n',err1);
fprintf('The estimated standard error of the Uncorrelated Option Value estimate is %d. \n',err2);
time = toc;

end
