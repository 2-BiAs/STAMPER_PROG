function bResult = AngleReversal(plToRef, plToCheck)
//    bResult = %F;    
//    for i = 2:size(plToRef, 1) - 1
//        vA1 = plToRef(i, :) - plToRef(i - 1, :);
//        vA2 = plToRef(i + 1, :) - plToRef(i, :);
//        
//        vB1 = plToCheck(i, :) - plToCheck(i - 1, :);
//        vB2 = plToCheck(i + 1,:) - plToCheck(i, :);
//        
//        bResultA = sign(det([vA1; vA2]));
//        bResultB = sign(det([vB1; vB2]));
//        
//        bResult = bResultA ~= bResultB;
//    end
    
        for i = 1:size(plToRef, 1) - 1
            vA1 = plToRef(i + 1, :) - plToRef(i, :);
            vB1 = plToCheck(i + 1, :) - plToCheck(i, :);

            bResultA = sign(round(10^6 * det([vA1; 1, 0])) / 10^6);
            bResultB = sign(round(10^6 * det([vB1; 1, 0])) / 10^6);

            bResult = bResultA ~= bResultB;
        if bResult then
//            pause
            break;
        end
    end

endfunction
