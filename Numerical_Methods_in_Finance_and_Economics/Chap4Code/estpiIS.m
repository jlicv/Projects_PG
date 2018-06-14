function z = estpiIS(m,L)
%L: num. of interval;
%m: num. of sampling.
%Mid-points of sub-intervals;
s = (0:(1/L):(1-1/L)) + 1/(2*L);
%get the values of the function to be evaluated, denoted as h, at 
%different midpoints.
hvals = sqrt(1-s.^2);
%cs helps to locate where each random dots, rand(1), may lie.
%cs(L) can be regarded as the scaling factor;
cs = cumsum(hvals);
est = zeros(m,1);
for j = 1:m
    %try to find which interval where rand falls in.
    %as s are midpoints, and that MATLAB indices begin at 1,
    %you need to plus one to find out the first interval.
    %value of loc varies from 1 to L.
    loc = sum(rand*cs(L) > cs) + 1;
    %Then you may get the estimate,it simply needs to stay in the
    %range[(k-1)/L,k/L],where k = loc. 
    x = (loc-1)/L + rand/L; 
    p = hvals(loc)/cs(L); %the g(x) function without L term.
    est(j) = sqrt(1-x.^2)/(p*L); %f(x) == 1, so this is h(x)f(x)/g(x);
end
z = 4*sum(est)/m;
end