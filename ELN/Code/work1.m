sigma_1 = 0.1;
sigma_2 = 0.1;
r=0.01;
rho=zeros(1,11);
value=zeros(1,11);
for i=1:11;
    rho(i)=(2*i-12)/10;
    y1= warrant(r,sigma_1,sigma_2,rho(i));
    value(i)=y1;
end
plot(rho,value);
xlabel('correlation coefficient \rho');
ylabel('Value of warrant');
legend('r=0.01 sigma_1 = 0.1 sigma_2 = 0.1');