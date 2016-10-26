function mIntersectionPairs = PolylineIntersectionPairs_New(plA, plB)
    mIntersectionPairs = [,];
    for i = 1:size(plA, 1) - 1
        for j = 1:size(plB, 1) - 1
            
            lnA = plA(i:i+1,:);
            lnB = plB(j:j+1,:);
            
            if Intersect(lnA, lnB) then
                mIntersectionPairs($+1, 1:2) = [i j];
                //disp(mIntersectionPairs($))
                //xpoly()
                //pause
            end
        end
    end
    //disp(mIntersectionPairs)
    //pause
endfunction
