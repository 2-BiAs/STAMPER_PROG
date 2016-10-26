function strmatOutput = BuildLevelCutToolPath(plRemovalArea, fRapidClearance, fSafetyClearance, fDoC)
    
    //TODO: Add a function to handle discontiguous areas... i.e. multiple calls
    //to this function with additional code to handle tool path between spearate areas.
    
    //DEFINE CONSTANTS
    sCodeRapid = "F(P7)";
    sCodeInFeed = "F(P8)";
    sCodeCrossFeed = "F(P9)";
    
    fScanOffset = fSafetyClearance;
        
    //BUILD RAPID BOUNDARY
    plBoundRapid = OffsetNormal(plBoundStart, fRapidClearance);

    //FIND BOUNDING BOXES
    rectBoundBox = GetBoundingBox(plListRemovealAreas)
    
    //CREATE LEVEL POLYLINE ARRAY (LIST)
    plListLevelLines = list();
    iLevelCount = int(rectBoundBox(4) / fDoC);
    
    for i=1:1:iLevelCount
        fZ_Level;
        fX_BoundLeft = rectBoundBox(1);
        fX_BoundRight = rectBoundBox(1) + rectBoundBox(3);
        
        plTemp = [fX_BoundLeft, fZ_Level; fX_BoundRight, FZ_Level];
        
        plListLevelLines($+1) = plTemp;
    end
    
    pause;
        
    //FIND INTERSECTIONS WITH LEVEL LINES
    
endfunction
