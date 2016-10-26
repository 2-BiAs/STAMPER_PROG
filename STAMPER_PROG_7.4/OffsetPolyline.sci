function plOutput = OffsetPolyline(plInput, mOffestRegimeBoundaries, mOffsetComponents)
    
    //plInput = FwdSelfIntSmoothing(plInput, 10, .05);
    
    iPointCount = size(plInput, 1);
    iSegmentCount = iPointCount - 1;
    iIntersectionCount = iSegmentCount - 1;
    
    lnOffsetSegmentBuffer = [];
    plOffsetPolylineBuffer = [];
    plOutputBuffer = [];
    
    iOutputPolylineCount = 1
    
    vOffsetArray = BuildOffsetMatrix(plInput, mOffestRegimeBoundaries, mOffsetComponents);
    
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
//        disp("Angle Reversal Detected.");
////        pause
//    else
//        plOutput = plOffsetPolylineBuffer;
//    end

//    plOffsetPolylineBuffer = RemoveKnots(plInput, plOffsetPolylineBuffer);
//    plOutput = plOffsetPolylineBuffer;
    
//////////////      plOffsetPolylineBuffer = FwdSelfIntSmoothing(plOffsetPolylineBuffer, 8, .030);
//////////////      plOffsetPolylineBuffer = FwdSelfIntSmoothing(plOffsetPolylineBuffer, 8, .030);
//////////////      plOffsetPolylineBuffer = FwdSelfIntSmoothing(plOffsetPolylineBuffer, 18, .075);
//////////////
//      plOffsetPolylineBuffer = plOffsetPolylineBuffer($:-1:1,1:2);
//      plOffsetPolylineBuffer = FwdSelfIntSmoothing(plOffsetPolylineBuffer, 6, .05);
////      plOffsetPolylineBuffer = plOffsetPolylineBuffer($:-1:1,1:2);
//      plOffsetPolylineBuffer = FwdSelfIntSmoothing(plOffsetPolylineBuffer, 8, .05);
//    plOffsetPolylineBuffer = RemoveInvertedCircles(plOffsetPolylineBuffer, 24);
//    plOffsetPolylineBuffer = RemoveInvertedCircles(plOffsetPolylineBuffer, 23);
//    plOffsetPolylineBuffer = RemoveInvertedCircles(plOffsetPolylineBuffer, 22);
//    plOffsetPolylineBuffer = RemoveInvertedCircles(plOffsetPolylineBuffer, 21);
//    plOffsetPolylineBuffer = RemoveInvertedCircles(plOffsetPolylineBuffer, 20);
    //plOffsetPolylineBuffer = RemoveSharpCorners(plOffsetPolylineBuffer, 30 * (%pi/180));
    plOutput = plOffsetPolylineBuffer;

    
endfunction
