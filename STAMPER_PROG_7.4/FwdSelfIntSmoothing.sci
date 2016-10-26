function plOutput = FwdSelfIntSmoothing(plInput, iN, iProjectionDist)
    iN = min(iN, size(plInput, 1) - 2);
    bIntersection = %F
    i = 1;
    while i <= size(plInput, 1) - iN - 1

        plOutput($+1,1:2) = plInput(i, 1:2);

        j = iN;
        while j >= 2
//            disp([i, j]);
            lnBoundTemp = plInput(i+j:i+j+1, 1:2);
            lnCheckTemp = plInput(i:i+1,1:2);

            vCheckTemp = lnCheckTemp(2,1:2) - lnCheckTemp(1,1:2);
            vCheckTemp = vCheckTemp/norm(vCheckTemp);
            lnCheckTemp(2,1:2) = lnCheckTemp(2,1:2) + vCheckTemp * iProjectionDist;                

            if Intersect(lnCheckTemp, lnBoundTemp) then
                [vX, vY] = IntersectionPoint(lnBoundTemp, lnCheckTemp);
                i = i + j;
                bIntersection = %T;
                plInput(i,1:2) = [vX, vY];
//                disp("Inverted Circle Removed");
//                pause
                break;
            else
                j = j - 1;
                bIntersection = %F;
            end            
        end

        if ~bIntersection then
            i = i + 1;
        end
    end
    plOutput($+1:$+iN+1,1:2) = plInput($-iN:$, 1:2);
    //         pause
endfunction
