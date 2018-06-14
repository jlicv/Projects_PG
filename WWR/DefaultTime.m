function[tau,R_lambda,time] = DefaultTime(T,timesteps,Npath)
tic
kappa = 0.05;
theta = 0.02;
miu = 0.01;
ln_lambda = zeros(Npath,timesteps);
lambda = zeros(Npath,timesteps);
density = zeros(Npath,timesteps);
ln_lambda(:,1) = log(0.02);
lambda(:,1) = 0.02;
dt = T/timesteps;
prob = zeros(Npath,timesteps);
tau = zeros(Npath,1);
N_lambda = zeros(Npath,1);
    function[value] = G(lambda,t,T)
        gamma = sqrt(kappa^2+2*miu^2);
        H1 = (2*gamma*exp(0.5*(gamma+kappa)*(T-t)))/((gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma);
        H2 = (2*exp(gamma*(T-t)))/((gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma);
        value = H1*exp(-H2*lambda);
    end
    function[value] = dGbydt(lambda,t,T)
        gamma = sqrt(kappa^2+2*miu^2);
        Denominator = ((gamma+kappa)*(exp(gamma*(T-t))-1)+2*gamma);
        H1 = (2*gamma*exp(0.5*(gamma+kappa)*(T-t)))/Denominator;
        H2 = (2*exp(gamma*(T-t)))/Denominator;
        value = 2*kappa*theta/miu^2*(-0.5*(gamma+kappa)+1)*H1*exp(-H2*lambda)+H1*(-4)*gamma^2*exp(gamma*(T-t))/Denominator^2;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------Part1: Default Time Simulation--------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:Npath
    ln_u = log(rand);
    %dp_tau_t_deno = 1-G(lnlambda(i,1),0,T);
    for j = 2:timesteps
        if ln_lambda(i,j-1)<ln_u
            W_lambda = randn(1);
            dln_lambda = 1/lambda(i,j-1)*(kappa*(theta-lambda(i,j-1))-0.5*miu^2)*dt+miu/sqrt(lambda(i,j-1))*sqrt(dt)*W_lambda;
            d_lambda = kappa*(theta-lambda(i,j-1))*dt + miu*sqrt(lambda(i,j-1))*sqrt(dt)*W_lambda;
            ln_lambda(i,j) = dln_lambda+ln_lambda(i,j-1);
            lambda(i,j) = lambda(i,j-1) + d_lambda;
            %density(i,j) = -dGbydt(lnlambda(i,1),0,(j-1)*dt)/dp_tau_t_deno;
            %prob(i,j) = prob(i,j-1)+density(i,j)*dt;
            N_lambda(i) = N_lambda(i) + W_lambda;
        else
            tau(i) = j*dt;
            break;
        end
    end
end

toc
time = tic-toc;
end
