another_rowfun_test = @(x) a_rowfun_test(3,2,x);
a_column = reshape(1:10,10,1);
a_table = table(a_column);
out = rowfun(another_rowfun_test,a_table);

