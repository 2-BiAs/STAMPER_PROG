function bIntersect = Intersect(lnA, lnB)
    bIntersect = (Same(lnA, lnB(1,:), lnB(2,:)) <= 0) & (Same(lnB, lnA(1,:), lnA(2,:)) <= 0);0
    if bIntersect then
        vA = [lnA(2,:) - lnA(1,:)];
        vB = [lnB(2,:) - lnB(1,:)];
        
        fTheta = acos(vA*vB'/(norm(vA) * norm(vB)));
        
        if fTheta == 0 | round(10^6 * fTheta) / 10 ^ 6 == round(10^6 * %pi) / 10^6 then //segments are colinear
            disp("WARNING: COLINEAR SEGMENTS");
            vB_N = vB * [0, -1; 1, 0]; //get normal
            if ~(Intersect(lnA, [lnB(1,:); lnB(1,:) + vB_N])...
                | Intersect(lnA, [lnB(2,:); lnB(2,:) + vB_N])...
                | Intersect(lnB, [lnA(1,:); lnA(1,:) + vB_N])...
                | Intersect(lnB, [lnA(2,:); lnA(2,:) + vB_N])) then
                bIntersect = %F                
            end
        end
    end
endfunction


