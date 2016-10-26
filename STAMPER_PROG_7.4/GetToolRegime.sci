function sToolRegime = GetToolRegime(fToolBiasAngle, fToolArcAngle, vA, sToolType)

    vTool = [cos(fToolAngle) sin(fToolAngle)]; 
    fAngle = acos(vTool*vA'/(norm(vTool) * norm(vA))) * sign(det([vTool;vA]))

//  revisit this to make work for right handed tool also
//    if sToolType == "LEFT" then
//       fAngle = fAngle; 
//    end
    
    if fAngle < 0 then fAngle = fAngle + %pi; end;
        
    if fAngle >= %pi/2 & fAngle < %pi then
        sToolRegime = "POINT";
    elseif fAngle > %pi/2 - fToolArcAngle & fAngle < %pi/2 then
        sToolRegime = "RADIUS";
    else
        sToolRegime = "UNDEFINED"
    end

endfunction

