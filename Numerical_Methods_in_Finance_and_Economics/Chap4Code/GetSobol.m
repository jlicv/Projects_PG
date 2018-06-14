function SobSeq = GetSobol(GenNumbers, x0, HowMany)
Nbits = 20;
factor = 2^Nbits;
BitNumbers = GenNumbers * factor;
SobSeq = zeros(HowMany + 1,1);
SobSeq(1) = fix(x0*factor);
for i = 1:HowMany
    c = min(find(bitget(i-1,1:16) == 0));
    SobSeq(i+1) = bitxor(SobSeq(i), BitNumbers(c));
end
SobSeq = SobSeq/factor;
end