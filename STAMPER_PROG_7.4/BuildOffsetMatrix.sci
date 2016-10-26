function vOffsets = BuildOffsetMatrix(vPoints, mOffsetRegimeBoundaries, mOffsetComponents)
    for i=1:size(vPoints, 1) - 1
        vA = [vPoints(i + 1, 1) - vPoints(i, 1), vPoints(i + 1,2) - vPoints(i,2)]; 
        if norm(vA) == 0 then
            disp("Zero Length Segment Detected")
            pause
        end
        vA_N = ([0 -1; 1 0] * vA')' / norm(vA);
        
        //flip for always positive Z component
        if sign(vA_N(2)) == -1 then
            vA_N = -vA_N;
        end
        
        vA_N_N = -vA / norm(vA); //norm part is new 4/21/16
        
        fTheta(i) = modulo(atan(vA(2) , vA(1)) + %pi, %pi);

        for j = 1:size(mOffsetRegimeBoundaries, 1)
            if fTheta(i) >= mOffsetRegimeBoundaries(j, 1) & fTheta(i) < mOffsetRegimeBoundaries(j, 2) | ...
            fTheta(i) + %pi >= mOffsetRegimeBoundaries(j, 1) & fTheta(i) + %pi < mOffsetRegimeBoundaries(j, 2) | ...
            fTheta(i) - %pi >= mOffsetRegimeBoundaries(j, 1) & fTheta(i) - %pi < mOffsetRegimeBoundaries(j, 2) then
                vOffsetComponents = mOffsetComponents(j, :);
                vOffsets(i, :) = vA_N * vOffsetComponents(1) + vA_N_N * vOffsetComponents(2) + vOffsetComponents(3:4);

////////////////////////////////
//                if vOffsets(i, 2) < -0.9 then
//                    pause;
//                end
////////////////////////////////

                break;
            end
        end
    end
endfunction
