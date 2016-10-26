function iSame = Same(lnA, p1, p2)
    
    d = lnA(2,:) - lnA(1,:);
    d1 = p1 - lnA(1, :);
    d2 = p2 - lnA(2, :);
    iSame = (d(1) * d1(2) - d(2) * d1(1)) * (d(1) * d2(2) - d(2) * d2(1));
endfunction
