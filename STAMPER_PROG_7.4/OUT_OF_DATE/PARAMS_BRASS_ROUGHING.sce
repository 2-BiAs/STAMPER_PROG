clear

//Load Raw Points from File
vPoints = csvRead("POINTS_16001_160409.csv", ",");  //Load Point file
vPoints(:,1) = -vPoints(:,1);  //Flip Point X-values to correspond with cutting on the left side of SPDT machine (CCW rotation)
vPoints = vPoints($:-1:1,:);  //Reverse the order of the points
//exec('PlotSurface.sce');

//Load Included Functions///////////
exec('GetToolRegime.sci');
exec('IntersectionPoint.sci');
exec('PolylineIntersectionPairs.sci');
exec('Same.sci');
exec('PolylineIntersection.sci');
exec('Intersect.sci');
exec('SuperPlot.sci');
exec('OffsetPolyline.sci');
exec('SlicePolyline.sci');
exec('JoinPolylines.sci');
exec('MathHelper.sci');
exec('BuildOffsetMatrix.sci');
exec('SlicePolylines.sci');
exec('OffsetPolylines.sci');
exec('AddInsideRad.sci');
exec('FlattenPolylineList.sci');
exec('ExtendEndPointsToZ.sci');
exec('AngleReversal.sci');
exec('MultiOffsetToBoundary.sci');
exec('BuildG_Code.sci');
exec('MergePolylineList.sci');
exec('IROffsetPolyline.sci');
exec('CompMultiOffsetToBnd.sci');
exec('NCompMultiOffsetToBnd.sci');
exec('ClearListEmpties.sci');
exec('VarRadInsideCorners.sci');
exec('RadOutsideCorners.sci');
exec('RemoveSharpCorners.sci');
exec('RemoveKnots.sci');
exec('DuperPlot.sci');
exec('RemoveInvertedCircles.sci');
exec('FwdSelfIntSmoothing.sci');

clc



//Define Tool Parameters/////////////////////////////////////////////////////
fToolRad = [.051, .05];   //[roughing finish]
fToolAngle = d2r([-85, -85]);   //[roughing finish]

//Calculate "Tool Vector" from tool angle
fToolVector = [cos(fToolAngle(1)) sin(fToolAngle(1))];

//Define Tool Offset Regimes //////////////////////////////////////////////
//vORBM = [%pi / 6, %pi / 2; %pi / 2, %pi] + fToolAngle(1); //Tool Regime angular boundary matrix
//mCutterCompOffsetComponents = [[fToolRad(1), 0], [fToolRad(1) * fToolVector];...   //offset .5 in the dirrection normal to the contact line and .5 along the tool vector
//                         [0, 0], [0, 0]];   //offset nothing for point tangency

//Define Tool Offset Regimes 
vORBM_ROUGH = [0, %pi] + fToolAngle(1); //Tool Regime angular boundary matrix
vORBM_FIN = [%pi / 6, %pi / 2; %pi / 2, %pi] + fToolAngle(2); //Tool Regime angular boundary matrix

//Define cutter comp offset components
//This describes how a surface point is mapped to a tool point
mCCOC_ROUGH = [[fToolRad(1), 0], [0 0]];   
mCCOC_FIN = [[fToolRad(2), 0], [fToolRad(2) * fToolVector];...   //offset .5 in the dirrection normal to the contact line and .5 along the tool vector
                         [0, 0], [0, 0]];   //offset nothing for point tangency

//Define Normal Offset Regimes////////////////////////////////////////////
vNormalOffsetRegime = [0, %pi];
mNickelUndersizeComp = [[-.100, 0], [0, 0]]; //Normal offset for Ni undersize (amount: 100um)
mNormalOffsetComponents = [[0, 0], [0, 0]];

//Define DoC Offset Regimes ////////////////////////////////////////////
vStartFix = [.51 - fToolAngle(1), .53 - fToolAngle(1)];
listMPOR = list([%pi / 6, 5*%pi / 6; 5*%pi / 6, vStartFix(1); vStartFix; vStartFix(2), %pi] + fToolAngle(1)); //Tool Regime angular boundary matrix
//listMPOR = list([%pi / 6, %pi / 2; %pi / 2, vStartFix(1); vStartFix; vStartFix(2), %pi] + fToolAngle(1)); //Tool Regime angular boundary matrix
listMPOR(2) = listMPOR(1);
listMPOR(3) = listMPOR(1);
//listMPOR(4) = listMPOR(1);
//listMPOR(5) = listMPOR(1);

////Offests for corner cut
//listMPOC_FIN = list([[0.010, 0], [0, 0]; [0.005, 0], [0, 0]; [0.010, 0], [0, 0]; [0.005, 0], [0, 0]]);
//listMPOC_FIN($+1) = [[0.010 0], [0, 0]; [0.001, 0], [0, 0]; [0.010 0], [0, 0]; [0.001, 0], [0, 0]];

//Offsets for final cut[s]
listMPOC_FIN = list([[0.005, 0], [0, 0]; [0.005, 0], [0, 0]; [0.005, 0], [0, 0]; [0.005, 0], [0, 0]]);
//listMPOC_FIN($+1) = [[0.0200, 0], [0, 0]; [0.020, 0], [0, 0]; [0.020, 0], [0, 0]; [0.020, 0], [0, 0]];
listMPOC_FIN($+1) = [[0.010, 0], [0, 0]; [0.010, 0], [0, 0]; [0.010, 0], [0, 0]; [0.010, 0], [0, 0]];
listMPOC_FIN($+1) = [[0.075, 0], [0, 0]; [0.015, 0], [0, 0]; [0.075, 0], [0, 0]; [0.015, 0], [0, 0]];

