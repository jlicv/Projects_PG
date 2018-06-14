gaussian_density = @(x,y,rhov_1s_2) 1/(sqrt(1-rhov_1s_2^2))*exp(0.5*(x.^2+y.^2)+(2*rhov_1s_2*x.*y-x.^2-y.^2)/(2*(1-rhov_1s_2^2)));

