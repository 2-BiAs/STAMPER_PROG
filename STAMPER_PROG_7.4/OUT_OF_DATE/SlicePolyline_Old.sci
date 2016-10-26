function listOutput = SlicePolyline(plInput, plBoundary, bRightHanded)
    iBoundaryIntersections = PolylineIntersectionPairs(plInput, plBoundary);

    //Build Boundary Intersection Point Buffer
    pInt = [,];
    for i=2:size(iBoundaryIntersections, 1)

        //Get Indicies for intersecting line segments
        iPInt = iBoundaryIntersections(i, 1);
        iBInt = iBoundaryIntersections(i, 2);

        //Build intersecting segments
        lnP = plInput(iPInt:iPInt + 1, :);
        lnB = plBoundary(iBInt:iBInt + 1, :);

        //Find intersection point
       [pInt(i,1), pInt(i,2)]  = IntersectionPoint(lnP, lnB);
    end
    
    //pause;
    //SuperPlot(list(pInt), list('rx'));
    
    //iOutputPolylineCount = size(iBoundaryIntersections, 1) - iStartOffset - 2;
    
    pInt(1,1:2) = plInput(1,:);
    pInt($+1,1:2) = plInput($,:);
    
    iBoundaryIntersections(1, 1) = 1;
    iBoundaryIntersections($+1, 1) = size(plInput,1);
    
    //the problem lies here somewhere
    
    
    listOutputBuffer = list();
    for i = 1:size(pInt, 1) - 1 
        iSubBufferStart = iBoundaryIntersections(i, 1) + 1;
        iSubBufferEnd = iBoundaryIntersections(i + 1, 1);
        
        listOutputBuffer(i) = ...
            [pInt(i, :); plInput(iSubBufferStart:iSubBufferEnd, :); pInt(i + 1, :)];
    end
    disp(size(pInt))
    
        //if point one is not on the boundary and point one falls on the same side of the boundary as the boundary segment normal RHR
    //then point 1 is with"in" the boundary
    lnB = plBoundary(1:2,:);
    vB = lnB(2,:) - lnB(1,:);
    vB_N = ([0 -1; 1 0]*vB')';
    
    pB_N = plBoundary(1,:) + vB_N;
    
    bStartPointInBoundary = Same(lnB, pB_N, plInput(1,:)) >= 0;
    //pause;
    listOutput = list();

    if bStartPointInBoundary ~= bRightHanded then
        for i = 1:2:size(listOutputBuffer)
            listOutput($+1) = listOutputBuffer(i);
        end
    else
        for i = 2:2:size(listOutputBuffer)
            listOutput($+1) = listOutputBuffer(i);
        end
    end
endfunction
