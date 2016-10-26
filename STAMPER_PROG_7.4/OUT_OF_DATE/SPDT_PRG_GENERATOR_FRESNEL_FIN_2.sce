//exec('Setup_Parameters_Finish.sce');
exec('Setup_Parameters.sce');

stacksize('max')

//Determine Boundary Profile (profile of last roughing cut)
listFinalRoughingPass = list(OffsetPolyline(vPoints, vNormalOffsetRegime, mNormalOffsetComponents)); //Boundary
plBoundWithRad = AddInsideRad(listFinalRoughingPass(1), vORBM_ROUGH, mCCOC_ROUGH);
vA = plBoundWithRad(2,:) - plBoundWithRad(1,:);
plBoundWithRad(1,1:2) = plBoundWithRad(1,1:2) + vA*.25;
plBoundWithRad = [plBoundWithRad(1,:) - [0 1]; plBoundWithRad(1:$,:)]; //Add vertical segment at end to define left edge
//
//pGrooveProfile = scf();
//axGrooveProfile = gca();
//axGrooveProfile.isoview = "on"
//
//SuperPlot(list(listFinalRoughingPass, plBoundWithRad), list('b--'))
//
//pause;

listFinalPass = list(vPoints);

//plBoundary = [-234 -2; -234 .15; 1 .15];
fZ_Clearance = .2 ;//

//Creat Figure and axis for graphical output
pGrooveProfile = scf();
axGrooveProfile = gca();
axGrooveProfile.isoview = "on"

[listCutPath, listCompedCutPath, iLevelIndices] = NCompMultiOffsetToBnd(list(vPoints), listMPOR, listMPOC_FIN, plBoundWithRad, 1, vORBM_FIN, mCCOC_FIN);

listCutPath = FlattenPolylineList(listCutPath);

listCompedCutPath = FlattenPolylineList(listCompedCutPath);
//listCompedCutPath = ClearListEmpties(listCompedCutPath);

listCompedCutPath = ExtendEndPointsToZ(listCompedCutPath, fZ_Clearance);
listCompedCutPath = MergePolylineList(listCompedCutPath);
listCompedCutPath = listCompedCutPath($:-1:1,:);

//SuperPlot(listCutPath, list('b--', 'r--'));
//SuperPlot(list(plWithRad), list('b--'));
//SuperPlot(list(plBoundary), list('b--'));
//axGrooveProfile.isoview = "on"

//plTooPath = BuildG_Code(listCutPath, iLevelIndices);

    //plCutPathComped = plCutPathComped($:-1:1,:);
    
    
pGrooveProfile = scf();
axGrooveProfile = gca();

    xpoly(plBoundWithRad(:,1), plBoundWithRad(:,2));
    xpPath = get("hdl");
    
    xpPath.line_style = 1;
    xpPath.polyline_style = 1;
    xpPath.mark_style = 1;
    xpPath.thickness = 2;
    xpPath.foreground = 5;
    
    xpoly(listCompedCutPath(:,1), listCompedCutPath(:,2));
    xpPath = get("hdl");
    
    xpPath.line_style = 4;
    xpPath.polyline_style = 4;
    xpPath.mark_style = 2;
    xpPath.thickness = 2;
    xpPath.foreground = 2;
    
    xpoly(listFinalPass(1)(:,1), listFinalPass(1)(:,2));
    xpPath = get("hdl");
    
    xpPath.line_style = 1;
    xpPath.polyline_style = 4;
    xpPath.mark_style = 1;
    xpPath.thickness = 2;
    xpPath.foreground = 3;
    
    xpoly(vPoints(:,1), vPoints(:,2));
    xpPath = get("hdl");
    
    xpPath.line_style = 1;
    xpPath.polyline_style = 1;
    xpPath.mark_style = 1;
    xpPath.thickness = 3;
    xpPath.foreground = 4;
 
//
axGrooveProfile.data_bounds=[min(listCompedCutPath(:,1)),min(listCompedCutPath(:,2));max(listCompedCutPath(:,1)),max(listCompedCutPath(:,2))];
axGrooveProfile.isoview = "on"

//pause

//for i=1:size(listCompedCutPath, 1)
//    if (round(listCompedCutPath(i, 2) * 10^6) / 10^6 == fZ_Clearance) & ~(round(listCompedCutPath(i, 1) * 10^6) / 10^6 == 0) then
//        sLineEndCode(i) = "F(P8)";
//    else
//        sLineEndCode(i) = "F(P7)";
//    end
//end
    sLineEndCode(1) = "F(P9)"; //Rapid to start point
for i=1:size(listCompedCutPath,1)-1
    vSegment = listCompedCutPath(i+1, :) - listCompedCutPath(i, :);
    fSegmentAngle(i) = atan(vSegment(2), vSegment(1)); //Returns segment angle in the interva (-pi, pi]
    fSegmentAngle(i) = fSegmentAngle(i) * 180 / %pi;
    fSegmentAngle(i) = round(fSegmentAngle(i)*100)/100; //Round to nearest .01;
    
    if fSegmentAngle(i) == 0 | fSegmentAngle(i) == 180 | fSegmentAngle(i) == 90 | fSegmentAngle(i) == -90 then
        sLineEndCode(i + 1) = "F(P9)";  //Rapid moves
    elseif fSegmentAngle(i) < -90 & fSegmentAngle(i) > -100
        sLineEndCode(i + 1) = "F(P8)"; //Infeed for steep plunging cuts
    else
        sLineEndCode(i + 1) = "F(P7)"; //Default feed for groove cuts
    end
    
    //Fix Feeds for Center
    if fSegmentAngle(i) == -90 & listCompedCutPath(i+1, 1) > -1
        sLineEndCode(i + 1) = "F(P8)"; //Infeed for steep plunging cuts
    end
    if fSegmentAngle(i) == 180 & fSegmentAngle(i) == -180 & listCompedCutPath(i, 1) > -1
        sLineEndCode(i + 1) = "F(P7)"; //Default feed for groove cuts
    end
end
pause

//sFileToSave = uigetfile("*.txt", directory, "Save Formatted Points As")
sFileToSave = "TEST_PRG.pgm"
fFile = mopen(sFileToSave, 'wt');
//mfprintf(fFile, ";Facet DoC = %s\n ;Wall DoC = %s\n", string(fDepthsOfCutFacet), string(fDepthsOfCutWall));
//mfprintf(fFile, ";Tool Rad = %f\n ;Tool Angle = %f\n ;Z Clearance Plane = %f\n\n\n\n", fToolRad, fToolAngle, fZ_Clearance);

for i=1:length(listCompedCutPath(:,1))
    mfprintf(fFile, "X%fZ%f", listCompedCutPath(i,1), listCompedCutPath(i,2));
    mfprintf(fFile, "   %s\n", sLineEndCode(i));
end
mclose(fFile);
