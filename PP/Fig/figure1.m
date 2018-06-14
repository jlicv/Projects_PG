rg=0.02;
r=0.06;
alpha1=0.3;
gamma1=0.1;
alpha2=0.4;
gamma2=0.1;
alpha3=0.3;
gamma3=0.15;
sigma=0.15;
value=zeros(3,20);
T=zeros(1,20);
for i=1:20;
    T(i)=i;
   
    value(1,i)=VA(T(i),5,800,800,r,rg,alpha1,gamma1,sigma)-VE(T(i),5,800,800,r,rg,alpha1,gamma1,sigma);
    value(2,i)=VA(T(i),5,800,800,r,rg,alpha2,gamma2,sigma)-VE(T(i),5,800,800,r,rg,alpha2,gamma2,sigma);
    value(3,i)=VA(T(i),5,800,800,r,rg,alpha3,gamma3,sigma)-VE(T(i),5,800,800,r,rg,alpha3,gamma3,sigma);
end
plot(T,value(1,:),T,value(2,:),T,value(3,:));
xlabel('time to maturity(years)');
ylabel('surrender option value');
legend('r=0.06 rg=0.02 alpha=0.3 gamma=0.1 sigma=0.15','Location','SouthEast','r=0.06 rg=0.02 alpha=0.4 gamma=0.1 sigma=0.15','Location','SouthEast','r=0.06 rg=0.02 alpha=0.3 gamma=0.15 sigma=0.15','Location','SouthEast');