rng(3124);
numtest = 100;
IS_estimate = zeros(numtest,1);
estimate_crude = zeros(numtest,1);
for i = 1:numtest
    IS_estimate(i) = estpiIS(1000,10);
    estimate_crude(i) = estpi(1000);
end
sd_IS = std(IS_estimate);
sd_crude = std(estimate_crude);
