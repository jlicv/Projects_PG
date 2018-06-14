%%
rhou_1u_2_sequence = -0.7:0.1:0.7;
price_u1 = zeros(length(rhou_1u_2_sequence),1) ;
price_u2 = price_u1;
price_u3 = price_u1;
price_u4 = price_u1;
price_u5 = price_u1;
error_u1 = price_u1;
error_u2 = price_u1;
error_u3 = price_u1;
error_u4 = price_u1;
error_u5 = price_u1;
time = price_u1;
NPath = 10000;
for i=1:length(rhou_1u_2_sequence)
    [price_u1(i),error_u1(i),time(i)] = CorrdiorVariance_QLV(5,4,NPath,0.2,rhou_1u_2_sequence(i),0.2,0.1,-0.3,-0.3);
    [price_u2(i),error_u2(i)] = CorrdiorVariance_QLV(5,1.5,NPath,0.2,rhou_1u_2_sequence(i),0.2,0.1,-0.3,-0.3);
    [price_u3(i),error_u3(i)]= CorrdiorVariance_QLV(5,1,NPath,0.2,rhou_1u_2_sequence(i),0.2,0.1,-0.3,-0.3);
    [price_u4(i),error_u4(i)] = CorrdiorVariance_QLV(5,0.8,NPath,0.2,rhou_1u_2_sequence(i),0.2,0.1,-0.3,-0.3);
    [price_u5(i),error_u5(i)] = CorrdiorVariance_QLV(5,0.2,NPath,0.2,rhou_1u_2_sequence(i),0.2,0.1,-0.3,-0.3);
end


%%
figure;
plot(rhou_1u_2_sequence,price_u1)
hold on;
plot(rhou_1u_2_sequence,price_u2)
plot(rhou_1u_2_sequence,price_u3)
plot(rhou_1u_2_sequence,price_u4)
plot(rhou_1u_2_sequence,price_u5)
legend('U=4','U=1.5','U=1','U=0.8','U=0.2','Location','best');
xlabel('Vol-Vol Correlation Parameter')
ylabel('Corridor variance');
hold off;
%%

