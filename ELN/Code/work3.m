
sigma_1 = 0.10;
sigma_2 = 0.10;
r=zeros(1,11);
rho=0;
value=zeros(1,11);
for i=1:11;
    r(i)=(i-1)/50;
    y1= warrant(r(i),sigma_1,sigma_2,rho);
    value(i)=y1;
end
plot(r,value);
xlabel('interest rate');
ylabel('Value of warrant');
legend('\rho=0 sigma_1 = 0.14 sigma_2 = 0.14');