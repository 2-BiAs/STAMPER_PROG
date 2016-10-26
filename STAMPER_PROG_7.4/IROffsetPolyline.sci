function plOutput = IROffsetPolyline(plInput, mOffestRegimeBoundaries, mOffsetComponents) //ignore angle reversal // 

    iPointCount = size(plInput, 1);
    iSegmentCount = iPointCount - 1;
    iIntersectionCount = iSegmentCount - 1;
    
    lnOffsetSegmentBuffer = [];
    plOffsetPolylineBuffer = [];
    plOutputBuffer = [];
    
    iOutputPolylineCount = 1
    
    vOffsetArray = BuildOffsetMatrix(plInput, mOffestRegimeBoundaries, mOffsetComponents);
//    pause
    //Offset each polyline segment according to vOffsetArray
    for i = 1:iSegmentCount
        
        lnA = plInput(i:i+1, :);
        lnOffsetSegmentBuffer(i*2-1:i*2,1:2) = lnA + [1 1]' * vOffsetArray(i, :);
    end

    //Find intersection point of each adjacent segment
    for i=1:iSegmentCount - 1
        [pIntersectionBuffer(i, 1), pIntersectionBuffer(i, 2)]  = IntersectionPoint(lnOffsetSegmentBuffer(i*2 - 1:i*2,:), lnOffsetSegmentBuffer(i*2 + 1:i*2 + 2, :));
    end

    plOffsetPolylineBuffer(1, :) = lnOffsetSegmentBuffer(1,:);
    plOffsetPolylineBuffer(iPointCount, :) = lnOffsetSegmentBuffer($, :);
    
    for i=1:iIntersectionCount
        plOffsetPolylineBuffer(i + 1, :) = pIntersectionBuffer(i, :);
    end
    
//    if AngleReversal(plInput, plOffsetPolylineBuffer) then
//        plOutput = [,];
//    else
        plOutput = plOffsetPolylineBuffer;
//    end
    
endfunction
