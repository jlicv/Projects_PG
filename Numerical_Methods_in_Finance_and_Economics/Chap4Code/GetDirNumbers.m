%Get Direction Numbers
function[v,m] = GetDirNumbers(p,m0,n)
degree = length(p) - 1;
p = p(2:degree);
m = [m0, zeros(1,n-degree)];
for i = (degree+1):n
    m(i) = bitxor(m(i-degree), 2.^degree*m(i-degree));
    for j = 1:(degree-1)
        m(i) = bitxor(m(i), 2^j * p(j) * m(i-j));
    end
end
v = m./(2.^(1:length(m)));
end