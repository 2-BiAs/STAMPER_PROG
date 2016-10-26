function listOutput = WeavePolylines(plA, plB, bRightHanded)
    listOutput = list();
    listOutputBufferA = list();
    listOutputBufferB = list();
    
//    mIntersections = PolylineIntersectionPairs_New(plA, plB);
    mIntersections = PolylineIntersectionPairs(plA, plB);

    if ~isempty(mIntersections) then

        for iIndex = 1:size(mIntersections, 1)
            i = mIntersections(iIndex, 1);
            j = mIntersections(iIndex, 2);

            lnA = [plA(i, :); plA(i + 1, :)]
            lnB = [plB(j, :); plB(j + 1, :)]
            
            //Find intersection point
            [pInt(iIndex,1), pInt(iIndex,2)]  = IntersectionPoint(lnA, lnB);
        end
        
        j = 1;
        i = 0;
        bLastPointReached = %F;
        mIntersections($+1, 1:2) = [0, 0];    //Add zero interection at end of list to stop loop
        while ~bLastPointReached
            if mIntersections(j, 1) == i then
                //printf("i = %d  j = %d\n", i, j);
                plOutputBufferA($+1,:) = pInt(j, :); //add intersection point to the end of the output buffer
                listOutputBufferA($+1) = plOutputBufferA;   //add the current polyline output buffer to the polyline output list
                plOutputBufferA = pInt(j, :);        //clear the output buffer—current intersection point first new member
                j = j + 1;
            else
                i = i + 1;
                //printf("i = %d  j = %d\n", i, j);
                plOutputBufferA($+1,1:2) = plA(i, :); //add point "i" from plA
                if i == size(plA, 1) then
                    bLastPointReached = %T; //if last point on plA added, end the loop
                end
            end
        end
        
        j = 1;
        i = 0;
        bLastPointReached = %F;
        while ~bLastPointReached
            if mIntersections(j, 2) == i then
                //printf("i = %d  j = %d\n", i, j);
                plOutputBufferB($+1,:) = pInt(j, :); //add intersection point to the end of the output buffer
                listOutputBufferB($+1) = plOutputBufferB;   //add the current polyline output buffer to the polyline output list
                plOutputBufferB = pInt(j, :);        //clear the output buffer—current intersection point first new member
                j = j + 1;
            else
                i = i + 1;
                //printf("i = %d  j = %d\n", i, j);
                plOutputBufferB($+1,1:2) = plB(i, :); //add point "i" from plA
                if i == size(plB, 1) then
                    bLastPointReached = %T; //if last point on plA added, end the loop
                end
            end
        end
        
        listOutputBufferA($+1) = plOutputBufferA;   //Add last sub PL of plA to output list
        listOutputBufferB($+1) = plOutputBufferB;
        
        vA = plA(mIntersections(1, 1) + 1, :) - plA(mIntersections(1, 1), :);
        vB = plB(mIntersections(1, 2) + 1, :) - plB(mIntersections(1, 2), :);
        
        bStartPointInBoundary = 1 == sign(det([vA; vB]));        
        if bStartPointInBoundary ~= bRightHanded then
            for i = 2:2:size(listOutputBufferB)
                listOutput($+1) = listOutputBufferA(i-1);
                listOutput($+1) = listOutputBufferB(i);
            end
        else
            for i = 2:2:size(listOutputBufferA)
                listOutput($+1) = listOutputBufferB(i - 1);
                listOutput($+1) = listOutputBufferA(i);
            end
        end
    else
        vA = plA(2,:) - plA(1,:);
        vB = plB(1,:) - plA(1,:);
        bIsLeft = 1 == int(det([vA; vB])); //change to sign
        if bIsLeft then
            listOutput($ + 1) = plA;
        end
        //ADD CODE HERE TO HANDLE THE CASE WHERE NO INTERSECTION BETWEEN plA and plB OCCURS
    end
    //disp(mIntersections);
   // pause
endfunction
