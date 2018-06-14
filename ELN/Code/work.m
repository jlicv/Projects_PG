r= 0.05;
sigma_1 = 0.4;
sigma_2 = 0.3;
rho=zeros(1,11);
value=zeros(1,11);
for i=1:11;
    rho(i)=(i-1)/10;
    y1= warrant(r,sigma_1,sigma_2,(i-1)/10);
    value(i)=y1;
end
plot(rho,value);
xlabel('correlation coefficient \rho');
ylabel('Value of warrant');
legend('r= 0.05 sigma_1 = 0.4 sigma_2 = 0.3');