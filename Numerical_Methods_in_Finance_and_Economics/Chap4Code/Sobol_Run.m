p = [1 0 1 1];
m = [1 3 7];
[v,m] = GetDirNumbers(p,m,6);
GetSobol(v,0,10);
%%
p = [1 0 1 1 1 1];
m = [1 3 5 9 11];
[v,m] = GetDirNumbers(p,m,8);
GetSobol(v,0.124,10);
