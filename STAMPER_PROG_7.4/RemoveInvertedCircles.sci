function plOutput = RemoveInvertedCircles(plInput, iN) //iN is the number of points per arc
    if size(plInput,1) >= iN + 1  then
        i = 1
        while i <= size(plInput, 1) - (iN + 1)
//        for i = 1:size(plInput, 1) - (iN + 1)
            
            lnBoundTemp = plInput(i+iN:i+iN+1, 1:2);
            lnCheckTemp = plInput(i:i+1,1:2);

            if Intersect(lnCheckTemp, lnBoundTemp) then
                [vX, vY] = IntersectionPoint(lnBoundTemp, lnCheckTemp);
                plOutput($+1,1:2) = [vX, vY];
                i = i + iN + 1;
                //                plInput(i,1:2) = [vX, vY];
                disp("Inverted Circle Removed");
            else
                plOutput($+1,1:2) = plInput(i, 1:2);
                i = i+1;
            end
        end
//        pause
        plOutput($+1:$+iN+1, 1:2) = plInput($ - iN:$, 1:2);
    else
        plOutput = plInput
        disp("Polyline Too Small to Remove Inverted Circle")
    end
endfunction
