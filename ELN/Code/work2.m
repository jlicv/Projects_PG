sigma_1 = 0.4;
sigma_2 = zeros(1,11);
r=0.05;
rho=0.5;
value=zeros(1,11);
for i=1:1;
    sigma_2(i)=i/10;
    y1= warrant(r,sigma_1,sigma_2(i),rho);
    value(i)=y1;
end
plot(sigma_2,value);
xlabel('sigma_2');
ylabel('Value of warrant');
legend('r=0.05 sigma_1 = 0.4 \rho=0.5');