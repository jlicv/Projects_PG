function h = Halton(n,b)
n0 = n;
h = 0;
f = 1/b;
while(n0>0)
    n1 = floor(n0/b);
    r = n0 - n1*b;
    h = h +f*r;
    f = f/b;
    n0 = n1;
end
end