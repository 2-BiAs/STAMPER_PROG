function strmatOutput = BuildLevelCutToolPath(plListRemovalAreas, fRapidClearance, fSafetyClearance, fDoC)
    
    //DEFINE CONSTANTS
    sCodeRapid = "F(P7)";
    sCodeInFeed = "F(P8)";
    sCodeCrossFeed = "F(P9)";
    
    fScanOffset = fSafetyClearance;
        
    //BUILD RAPID BOUNDARY
    plBoundRapid = OffsetNormal(plBoundStart, fRapidClearance);

    //FIND BOUNDING BOX

    
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
