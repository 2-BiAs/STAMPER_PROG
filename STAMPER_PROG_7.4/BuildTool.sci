function toolOutput = BuildTool(sType, fRad, fIncludedAngle, fBiasAngle)
    
    //Add cases for different tool types. Tool Must be a convex polygon.
    
    toolOutput.Vector = [cos(fBiasAngle) sin(fBiasAngle)];
    
    select sType
    case "FULL_RADIUS" then
        //toolOutput.ORBM = [fIncludedAngle / 2 %pi-fIncludedAngle / 2] + fBiasAngle; //NEED TO FIX THIS
        toolOutput.ORBM = [0 %pi];
        toolOutput.TCOC = [[fRad, 0], [0 0]];
    case "SPLIT_RADIUS_RIGHT_HANDED" then
        toolOutput.ORBM = [fIncludedAngle, %pi / 2; %pi / 2, %pi] + fBiasAngle;
        toolOutput.TCOC = [[fRad, 0], [fRad * toolOutput.Vector]; [0, 0], [0, 0]];

//      Tool Compensation Offset Components (TCOC) details for RH split radius tool
//          Radius Ttangency Regime: Offset fRad in the dirrection normal to the contact line
//                                   Offset fRad along the tool vector
//          Point Tangency Regime: offset nothing

    case "SPLIT_RADIUS_LEFT_HANDED" then
        toolOutput.ORBM = [0, %pi/2; %pi/2, %pi/2 + fIncludedAngle] + fBiasAngle;
        toolOutput.TCOC = [[fRad, 0], [fRad * toolOutput.Vector]; [0, 0], [0, 0]];
    else
        sError = sprintf("%s is not a recognized tool type", sType);
        error(101, sError);
    end
endfunction
