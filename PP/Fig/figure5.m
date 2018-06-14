rg=0.02;
r=0.07;
alpha=0.3;
gamma=0.1;
T=zeros(1,20);
sigma=0.15;
value=zeros(4,20);

for i=20:-1:1;
    T(i)=i;
   
    value(1,i)=VE(T(i),5,100,100,r,rg,alpha,gamma,sigma);
    value(2,i)=VA(T(i),5,100,100,r,rg,alpha,gamma,sigma)-value(1,i);
    value(3,i)=((1+rg)^T(i))/((1+r)^T(i))*100;
    value(4,i)=VA(T(i),5,100,100,r,rg,alpha,gamma,sigma);
    
   
end
plot(T,value(1,:),T,value(2,:),T,value(3,:),T,value(4,:));
axis([2 20 0 120]);
xlabel('time to maturity');
ylabel('value');
gtext('European contract')
gtext('surrender option');
gtext('bond component');
gtext('American contract')
title('r=0.07 rg=0.02 alpha=0.3 gamma=0.1 sigma=0.15  ')