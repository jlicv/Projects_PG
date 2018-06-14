function [ price ] = warrantnocall(R,Sigma1,Sigma2,Rho)
% Description: This part introduces the lattice tree for the stock price movement of the
% two underlying assets.
% By: Jiexiong Li & Juncheng Li
% Time: 2017/04/14
% Assuming that lambda are the same for both underlying assets.
lambda_1 = sqrt(3);
lambda_2 = sqrt(3);
lambda = sqrt(3);
r= R;
sigma_1 = Sigma1;
sigma_2 = Sigma2;
rho = Rho;
% Size of the time is annualized, by the proportion to the total business
% day in a year.
dt = 3/252;



% Probability formulas come from Page 92, Chapter 1, on the multi-state
% extension part.

p_uu = 0.25 * (1/lambda^2 + sqrt(dt)/lambda*((r-(sigma_1^2)/2)/sigma_1 + (r-(sigma_2^2)/2)/sigma_2) + rho/lambda^2);
p_ud = 0.25 * (1/lambda^2 + sqrt(dt)/lambda*((r-(sigma_1^2)/2)/sigma_1 - (r-(sigma_2^2)/2)/sigma_2) - rho/lambda^2);
p_dd = 0.25 * (1/lambda^2 + sqrt(dt)/lambda*(-(r-(sigma_1^2)/2)/sigma_1 - (r-(sigma_2^2)/2)/sigma_2) + rho/lambda^2);
p_du = 0.25 * (1/lambda^2 + sqrt(dt)/lambda*(-(r-(sigma_1^2)/2)/sigma_1 + (r-(sigma_2^2)/2)/sigma_2) - rho/lambda^2);
p_00 = 1 - (p_uu + p_ud + p_dd + p_du);
u_1 = exp(lambda_1 * sigma_1 * sqrt(dt));
d_1 = exp(-lambda_1 * sigma_1 * sqrt(dt));
u_2 = exp(lambda_2 * sigma_2 * sqrt(dt));
d_2 = exp(-lambda_2 * sigma_2 * sqrt(dt));
% Stock 1 represents the Wal-Mart Stores Inc.
% Stock 2 represents the Intel Corp.
% Lattice for the stock
l1=log(0.87)/log(u_1);
l2=log(0.87)/log(u_2);

W=zeros(8,22,350,350,22);
%
P=8;
p=P-1;
for N=22:-1:1;n=N-1;
    for i=-21*p-n+169:1:21*p+n+169;
        for j=-21*p-n+169:1:21*p+n+169;
            for K=1:1:max(1,N-max(0,max(ceil(l1)-i+169,ceil(l2)-j+169)));k=K-1;
                if n==21
                    if i-169>l1&&j-169>l2
                        W(P,N,i,j,K)=1+k/21*0.04075;
                    else
                        W(P,N,i,j,K)=min(1,min(u_1^(i-169)/0.87,u_2^(j-169)/0.87))+k/21*0.04075;
                    end
                else
                    W(P,N,i,j,K)=exp(-r*dt)*(p_uu*W(P,N+1,i+1,j+1,gcou(i+1,j+1,K,l1,l2))+p_ud*W(P,N+1,i+1,j-1,gcou(i+1,j-1,K,l1,l2))+p_du*W(P,N+1,i-1,j+1,gcou(i-1,j+1,K,l1,l2))+p_dd*W(P,N+1,i-1,j-1,gcou(i-1,j-1,K,l1,l2))+p_00*W(P,N+1,i,j,gcou(i,j,K,l1,l2)));
                end
            end
        end
    end
end

for P=7:-1:2;p=P-1;
    for N=22:-1:1;n=N-1;
        for i=-21*p-n+169:1:21*p+n+169;
            for j=-21*p-n+169:1:21*p+n+169;
                for K=1:1:max(1,N-max(0,max(ceil(l1)-i+169,ceil(l2)-j+169)));k=K-1;
                    if n==21
                        
                        W(P,N,i,j,K)=W(P+1,1,i,j,1)+k/21*0.04075;
                        
                    else
                        W(P,N,i,j,K)=exp(-r*dt)*(p_uu*W(P,N+1,i+1,j+1,gcou(i+1,j+1,K,l1,l2))+p_ud*W(P,N+1,i+1,j-1,gcou(i+1,j-1,K,l1,l2))+p_du*W(P,N+1,i-1,j+1,gcou(i-1,j+1,K,l1,l2))+p_dd*W(P,N+1,i-1,j-1,gcou(i-1,j-1,K,l1,l2))+p_00*W(P,N+1,i,j,gcou(i,j,K,l1,l2)));
                    end
                end
            end
        end
    end
end

P=1;
for N=22:-1:1;n=N-1;
    for i=-21*p-n+169:1:21*p+n+169;
        for j=-21*p-n+169:1:21*p+n+169;
            for K=1:1:max(1,N-max(0,max(ceil(l1)-i+169,ceil(l2)-j+169)));k=K-1;
                if n==21
                    W(P,N,i,j,K)=W(P+1,1,i,j,1)+0.04075;
                else
                    W(P,N,i,j,K)=exp(-r*dt)*(p_uu*W(P,N+1,i+1,j+1,gcou(i+1,j+1,K,l1,l2))+p_ud*W(P,N+1,i+1,j-1,gcou(i+1,j-1,K,l1,l2))+p_du*W(P,N+1,i-1,j+1,gcou(i-1,j+1,K,l1,l2))+p_dd*W(P,N+1,i-1,j-1,gcou(i-1,j-1,K,l1,l2))+p_00*W(P,N+1,i,j,gcou(i,j,K,l1,l2)));
                end
            end
        end
    end
end
price=W(1,1,169,169,1);
