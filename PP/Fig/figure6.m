rg=0.02;
r=zeros(1,20);
alpha=0.3;
gamma=0.1;
T=20;
sigma=0.15;
value=zeros(4,20);

for i=20:-1:1;
    r(i)=i/100;
   
    value(1,i)=VE(T,5,100,100,r(i),rg,alpha,gamma,sigma);
    value(2,i)=VA(T,5,100,100,r(i),rg,alpha,gamma,sigma)-value(1,i);
    value(3,i)=((1+rg)^T)/((1+r(i))^T)*100;
    value(4,i)=VA(T,5,100,100,r(i),rg,alpha,gamma,sigma);
    
   
end
plot(r,value(1,:),r,value(2,:),r,value(3,:),r,value(4,:));
axis([0.01 0.2 0 120]);
xlabel('interest rate');
ylabel('value');
gtext('European contract')
gtext('surrender option');
gtext('bond component');
gtext('American contract')
title(' rg=0.02 alpha=0.3 gamma=0.1 sigma=0.15 maturity=20years ')