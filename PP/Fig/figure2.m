alpha = zeros(10,10);
gamma = zeros(10,10);
r=0.06;
rg=0.02;
sigma=0.15;
value1=zeros(10,10);
value2=zeros(10,10);
for i=11:-1:1;
    for j=11:-1:1;
        
            
        
        alpha(i,j)=(i-1)/20;
        gamma(i,j)=(j-1)/20;
        
        value1(i,j)=VA(20,5,100,100,r,rg,alpha(i,j),gamma(i,j),sigma)-VE(20,5,100,100,r,rg,alpha(i,j),gamma(i,j),sigma);
        
    end
    
end

surf(alpha,gamma,value1);

axis([0 0.5 0 0.5 80 110]);
xlabel('alpha');
ylabel('gamma');
zlabel('contract value(with surrender right)')
legend('r=0.06 rg=0.02 sigma=0.15 maturity=20years');