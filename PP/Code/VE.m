function [ price,time ] = VE(T,K,I,J,r,rg,alpha,gamma,sigma)
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%By: Juncheng Li
%Date:2016/04/24
%Description: Pricing The Participating Life Policy, with implicit scheme.
%Achknowledgments: Jiexiong Li, he contributes a lot in the preivous
%assignment, and the code of this assignment takes a lot of inspiration from
%his brilliant work.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------Part1: Initialization---------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pbar = 2000;
Abar = 1000;
P0 = 100;
A0 = 100;
da = Abar/I;
dp = Pbar/J;
j0 = P0/dp;
V = zeros(T+1,K+1,I+1,J+1);
H = zeros(I-1,1);
G = zeros(I-1,1);
E = zeros(I-1,1);
ds = 1/K;

for i = I-1:-1:1
    E(i) = r*ds*i/2 - sigma^2*i^2*ds/2;
    H(i) = 1 + r*ds + sigma^2*ds*i^2;
    G(i) = -r*i*ds/2 - sigma^2*ds*i^2/2;
end
% a is the diagonal line;
% b is the sub-diagonal line;
% c is the super-diagonal line;
a = zeros(I-1,1);
b = zeros(I-2,1);
c = zeros(I-2,1);
a(1:I-2,1) = H(1:I-2,1);
a(I-1,1) = H(I-1,1)+2*G(I-1,1);
b(1:I-3,1) = E(2:I-2,1);
b(I-2,1) = E(I-1,1) - G(I-1,1);
c(1:I-2,1) = G(1:I-2,1);
%coef = gallery('tridiag',c,d,e);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------Part2: Terminal Payoff--------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V(T) = P(T), so it has nothing to do with i.
payoff=zeros(I+1,J);
for i=I+1:-1:1
    for j=J:-1:j0
        payoff(i,j) = max(j*dp,(1+rg)^T*j0*dp);
    end
end
for i = I+1:-1:1
    for j = J:-1:j0
        jwave = j + max(rg*j, alpha*(((i-1)*da/dp-j) - gamma*j));
        jfloor = floor(jwave);
        if jfloor + 1 > J
            VExtra = payoff(i,J) + (jwave - J)*(payoff(i,J)-payoff(i,J-1)); %Extrapolation
            V(20,1,i,j) = VExtra;
        else
            VInter = (1-(jwave - jfloor))*payoff(i,jfloor) + (jwave - jfloor)*payoff(i,jfloor+1); %Interpolation
            V(20,1,i,j) = VInter;
        end
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------Part3: Jump Conditions-------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% V & A is argued to be consecutive over different time period, in this
% way,you can apply interpolation/extrapolation in a discrete setting.
for t =T:-1:2
    for k = 1:K+1
        if k == K+1 
            %Incorporate the Jump Condition.
            for i = I+1:-1:1
                for j = J:-1:j0
                    jwave = j + max(rg*j, alpha*(((i-1)*da/dp-j) - gamma*j));
                    jfloor = floor(jwave);
                    if jfloor + 1 > J
                        VExtra = V(t,k,i,J) + (jwave - J)*(V(t,k,i,J)-V(t,k,i,J-1)); %Extrapolation
                        V(t-1,1,i,j) = VExtra; 
                    else
                        VInter = (1-(jwave - jfloor))*V(t,k,i,jfloor) + (jwave - jfloor)*V(t,k,i,jfloor+1); %Interpolation
                        V(t-1,1,i,j) = VInter; 
                    end

                end
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------Part4: Boundary Conditions-----------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            for j = J:-1:j0
                V(t,k+1,1,j) = (1-r*ds)*V(t,k,1,j); %When the Asset Value=0;
                B = reshape(V(t,k,2:I,j),I-1,1); %Array becomes n*1 matrix.
                B(1) = B(1) - E(1)*(1-r*ds)*V(t,k,1,j);  
                temp = tridiag(a,[0;b],[c;0],B);
                temp = reshape(temp,1,1,I-1); %Turn matrix back to array.
                V(t,k+1,2:I,j) = temp; %So you can assign the array with a new value.
                V(t,k+1,I+1,j) = 2*V(t,k+1,I,j) - V(t,k+1,I-1,j); %When the Asset Value = Inf,a.k.a.,Smooth Parsing Condition;
            end
        end
    end
end
%At the last period, you don't need to incorporate the jump condition
%anymore.
t = 1;
for k = 1:K
    for j = J:-1:j0
        V(t,k+1,1,j) = (1-r*ds)*V(t,k,1,j);
        B = reshape(V(t,k,2:I,j),I-1,1);
        B(1) = B(1) - E(1)*(1-r*ds)*V(t,k,1,j);
        temp = tridiag(a,[0;b],[c;0],B);
        temp = reshape(temp,1,1,I-1);
        V(t,k+1,2:I,j) = temp;
        V(t,k+1,I+1,j) = 2*V(t,k+1,I,j) - V(t,k+1,I-1,j);
    end
end

price = V(1,K+1,A0/da,j0);
toc
time = tic - toc;
end

