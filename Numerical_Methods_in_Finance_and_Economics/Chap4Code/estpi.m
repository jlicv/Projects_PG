function out = estpi(m)
z = sqrt(1-rand(1,m).^2);
out = 4*sum(z)/m;
end