function iIntersectionIndex = PolylineSelfIntersect(lnA)
    iIntersectionIndex = 0;
    bIntersection = %F;
    for i = 1:size(lnA, 1) - 1
        for j =  1:size(lnA, 1) - 1
            if abs(i - j) <= 1 then break; end
            if Intersect(lnA(i:i+1,:), lnA(j:j+1, :)) then
                bIntersection = %T;
                break;
            end
        end
        if bIntersection then
            iIntersectionIndex = i;
            break;
        end
    end
endfunction
