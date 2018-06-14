function[tau,time] = DefaultDensity(T,timesteps,Npath)
tic
r = 0.02;
sigma = 0.3;
kappa = 0.05;
theta = 0.02;
miu = 1;
strike = 100;
lambda_zero = 0.02;

V = zeros(Npath,1);
lambda = zeros(Npath,timesteps);
density = zeros(timesteps,1);
prob = zeros(timesteps,1);
tau = zeros(Npath,1);
rand_lambda = zeros(Npath,timesteps);
rand_asset = zeros(Npath,timesteps);
lambda(:,1) = lambda(:,1) + lambda_zero;
dt = T/timesteps;
    function[value] = G(lambda,t,T)
        gamma = sqrt(kappa^2+2*miu^2);
        Denominator = (gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma;
        H1 = ((2*gamma*exp(0.5*(gamma+kappa)*(T-t)))/Denominator)^(2*kappa*theta/(miu^2));
        H2 = 2*((exp(gamma*(T-t))-1))/((gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma);
        value = H1*exp(-H2*lambda);
    end
    function[value] = dGbydt(lambda,t,T)
        gamma = sqrt(kappa^2+2*miu^2);
        Denominator = (gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma;
        %let tprime = T-t, by the chain rule you can get the
        %corresponding derivative;
        H1_Numerator = (2*gamma*exp(0.5*(gamma+kappa)*(T-t)));
        H2_Numerator = 2*((exp(gamma*(T-t))-1));
        H1 = (H1_Numerator/Denominator)^(2*kappa*theta/(miu^2));
        H2 = H2_Numerator/Denominator;
        dH1_dtprime = (0.5*(gamma+kappa)*2*gamma*Denominator-(gamma+kappa)*gamma*exp(gamma*(T-t))*H1_Numerator)/(Denominator^2);
        value_first = 2*kappa*theta/(miu^2)*(H1_Numerator/Denominator)^(2*kappa*theta/(miu^2)-1)*dH1_dtprime*exp(-H2*lambda);
        dH2_dtprime = (2*gamma*exp(gamma*(T-t))*Denominator-(gamma+kappa)*gamma*exp(gamma*(T-t))*H2_Numerator)/(Denominator^2);
        value_second = H1*lambda*dH2_dtprime*exp(-H2*lambda);
        value = -1*(value_first+value_second);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Part0: Density Simulation-----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dp_tau_t_deno = 1-G(lambda_zero,0,T);
for j = 2:timesteps
    density(j) = -dGbydt(lambda_zero,0,(j-1)*dt)/dp_tau_t_deno;
    prob(j) = prob(j-1)+density(j)*dt;
end
            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------Part1: Default Time Simulation--------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:Npath
%     u = rand;   
%     for j = 2:timesteps
%         if prob(i,j)<u
%             rand_lambda(i,j-1) = randn;
%             rand_asset(i,j-1) = randn;
%             lndlambda = 1/lambda(i,j-1)*(kappa*(theta-lambda(i,j-1))-0.5*miu^2)*dt+miu/sqrt(lambda(i,j-1))*sqrt(dt)*rand_lambda(i,j-1);
%             lambda(i,j) = exp(lndlambda)*lambda(i,j-1);   
%         else
%             tau(i) = j*dt;
%             break;
%         end
%     end
% end

toc
time = tic-toc;
end
