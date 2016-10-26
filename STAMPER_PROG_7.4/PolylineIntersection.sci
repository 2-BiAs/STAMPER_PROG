function bIntersect = PolylineIntersection(plA, plB)
    bIntersect = %F;
    for i = 1:size(plA, 1) - 1
        for j = 1:size(plB, 1) - 1
            if Intersect(plA(i:i+1,:), plB(j:j+1,:)) then
                bIntersect = %T;
                break;
            end
        end
        if bIntersect then break; end 
    end
endfunction
