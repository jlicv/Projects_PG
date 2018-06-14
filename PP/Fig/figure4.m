rg=0.02;
r1=0.04;
r2=0.07;
r3=0.1;
alpha=0.3;
gamma=0.1;

sigma=0.15;
value=zeros(3,20);
T=zeros(1,20);
for i=20:-1:1;
    T(i)=i;
   
    value(1,i)=VA(T(i),5,800,800,r1,rg,alpha,gamma,sigma);
    value(2,i)=VA(T(i),5,800,800,r2,rg,alpha,gamma,sigma);
    value(3,i)=VA(T(i),5,800,800,r3,rg,alpha,gamma,sigma);
   
    
   
end
plot(T,value(1,:),T,value(2,:),T,value(3,:));
axis([2 20 92 112]);
xlabel('time to maturity(years)');
ylabel('value');
title('rg=0.02 alpha=0.3 gamma=0.1 sigma=0.15')
gtext('r=0.04');
gtext('r=0.07');
gtext('r=0.1');