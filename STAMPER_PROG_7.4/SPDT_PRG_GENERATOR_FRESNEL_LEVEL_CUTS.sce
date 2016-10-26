//exec('Setup_Parameters_Finish.sce');
exec('Setup_Parameters.sce');
//stacksize('max')

fZ_ClearPlane = 1;
fZ_ChipBreakMove = .5; //mm Amount to retract tool
fDOC = -.05;


toolT1 = BuildTool('FULL_RADIUS', .051, 35 * (%pi / 180), (5 + 35/2) * (%pi / 180));

plFinalProfile = OffsetNormal(plPoints, .050);

//Build the multipass boundary
plMultipassBoundary = OffsetPolyline(plFinalProfile, toolT1.ORBM, toolT1.TCOC);
pgMultipassBoundary = [plMultipassBoundary(1, 1), -10; plMultipassBoundary; plMultipassBoundary($, 1), -10];
//plLeftBound = [-234 2; -234 -1];
//plTempBound = SlicePolyline(plMultipassBoundary, plLeftBound, %F);
//plMultipassBoundary = [-234 2; plTempBound(1)];

plFirstPass = [-234 .4; plPoints($, 1) .4];

//Setup Offset Regime Boundary Matrix
mORBM = [0, %pi];
//Setup Normal Offset Components
mNOC = [[-fDOC, 0], [0, 0]];

//[listToolPath, iLevelIndicies] = LvlMultiOffsetToBoundary(plFirstPass, list(mORBM), list(mNOC), plMultipassBoundary, 1, %F)

listToolPath = LevelMultipass(plFirstPass, pgMultipassBoundary, fDOC)

DuperPlot(plPoints);
DuperPlot(plFinalProfile);
DuperPlot(plMultipassBoundary);
DuperPlot(plFirstPass);
DuperPlot(listToolPath(1));




