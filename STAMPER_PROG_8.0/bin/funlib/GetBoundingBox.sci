function rectBoundingBox = GetBoundingBox(pPoints)
    //Returns the rect representing the bounding box of the set of points
    
    fMaxX = max(max(pPoints(:,1)), max(pPoints(:,1)));
    fMinX = min(min(pPoints(:,1)), min(pPoints(:,1)));
    
    fMaxZ = max(max(pPoints(:,2)), max(pPoints(:,2)));
    fMinZ = min(min(pPoints(:,2)), min(pPoints(:,2)));
    
    rectBoundingBox = [fMinX, fMaxZ, fMaxX - fMinX, fMaxZ - fMinZ];
    
endfunction
