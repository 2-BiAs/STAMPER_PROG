function plOutput = RemoveKnots(plA, plB)
//    plOutput(1,1:2) = plB(1,1:2)
//    for i = 2:size(plA, 1) - 1
//        vA1 = plA(i + 1, :) - plA(i, :);
//        vB1 = plB(i + 1, :) - plB(i, :);
//
//        bResultA = sign(round(10^6 * det([vA1; 1, 0])) / 10^6);
//        bResultB = sign(round(10^6 * det([vB1; 1, 0])) / 10^6);
//
//        bResult = bResultA ~= bResultB;
//        if ~bResult then
//            plOutput($+1, 1:2) = plB(i, 1:2);
//        end
//    end
//    plOutput($+1,1:2) = plB($,1:2)
    
    plOutput(1,1:2) = plB(1,1:2)
    for i = 2:size(plA, 1) - 1
        //Get segments from plInput
        ln1A = plA(i-1:i, :);
        ln2A = plA(i:i+1, :);
        
        ln1B = plB(i-1:i, :);
        ln2B = plB(i:i+1, :);
        
        //Segments --> Vectors
        v1A = ln1A(2, :) - ln1A(1,:);
        v2A = ln2A(2, :) - ln2A(1,:);
        
        v1B = ln1B(2, :) - ln1B(1,:);
        v2B = ln2B(2, :) - ln2B(1,:);

        //Caculate angles between vectors
        f1A = atan(v1A(2), v1A(1));
        f2A = atan(v2A(2), v2A(1));
        
        f1B = atan(v1B(2), v1B(1));
        f2B = atan(v2B(2), v2B(1));
        
        fCornerAngleA = abs(f1A - f2A);
        fCornerAngleB = abs(f1B - f2B);
        
        disp([fCornerAngleA, fCornerAngleB])
        
        if sign(fCornerAngleA) ==  sign(fCornerAngleB) then
            plOutput($+1, 1:2) = plB(i, 1:2);
        end
    end
    plOutput($+1,1:2) = plB($,1:2)
endfunction
