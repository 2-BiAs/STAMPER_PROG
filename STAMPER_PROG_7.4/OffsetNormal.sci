function plOutput = OffsetNormal(plInput, fDist)
    //Setup Offset Regime Boundary Matrix
    mORBM = [0, %pi];
    
    //Setup Normal Offset Components
    mNOC = [[fDist, 0], [0, 0]];
    
    plOutput = OffsetPolyline(plInput, mORBM, mNOC);
    
endfunction
