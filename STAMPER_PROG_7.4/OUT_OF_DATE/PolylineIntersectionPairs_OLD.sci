function iIntersectionPairs = PolylineIntersectionPairs(plA, plB)
    iIntersectionPairs = [,];
    for i = 1:size(plA, 1) - 1
        bIntersect = %F;
        for j = 1:size(plB, 1) - 1
            if Intersect(plA(i:i+1,:), plB(j:j+1,:)) then
                bIntersect = %T;
                break;
            end
        end
        if bIntersect then
            iIntersectionPairs($+1, :) = [i, j];
        end
    end
endfunction
