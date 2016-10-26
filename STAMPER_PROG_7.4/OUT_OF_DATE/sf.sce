clear

//Load Raw Points from File
vPoints = csvRead("POINTS_16001_160409.csv", ";");  //Load Point file
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
exec('AngleReversal.sci');

clc

fToolRad = [.5, .05];
fToolAngle = d2r([-85, -85]);
fToolVector = [cos(fToolAngle(1)) sin(fToolAngle(1))];

//Define Tool Offset Regimes 
vORBM = [%pi / 6, %pi / 2; %pi / 2, %pi] + fToolAngle(1); //Tool Regime angular boundary matrix
mCutterCompOffsetComponents = [[fToolRad(1), 0], [fToolRad(1) * fToolVector];...   //offset .5 in the dirrection normal to the contact line and .5 along the tool vector
                         [0, 0], [0, 0]];   //offset nothing for point tangency

vNormalOffsetRegime = [0, %pi];
mNiUndersizeOffsetComponents = [[-.085, 0], [0, 0]];

vStartFix = [.51 - fToolAngle(1), .53 - fToolAngle(1)];
vORBM2 = [%pi / 6, %pi / 2; %pi / 2, vStartFix(1); vStartFix; vStartFix(2), %pi] + fToolAngle(1); //Tool Regime angular boundary matrix
mDoC_OffsetComponents = [[0.0071 0], [0, 0]; [0.00113, 0], [0, 0]; [0.0071 0], [0, 0]; [0.00113, 0], [0, 0]]; 


vPreNiSurface = list(OffsetPolyline(vPoints, vNormalOffsetRegime, mNiUndersizeOffsetComponents));




vOffsetPoints = list(vPreNiSurface);

plWithRad = AddInsideRad(vOffsetPoints(1)(1), vORBM, mCutterCompOffsetComponents)
SuperPlot(list(vOffsetPoints, plWithRad), list('b--'));

pause
mNiUndersizeOffsetComponents = [[.005, 0], [0, 0]];
plWithRad = OffsetPolyline(plWithRad, vORBM2, mDoC_OffsetComponents);
plBoundary = plWithRad;
plBoundary = [plBoundary(1,:) + [0 1]; plBoundary(1:$,:)];

mDoC_OffsetComponents = [[0.01 0], [0, 0]; [0.005, 0], [0, 0]; [0.01 0], [0, 0]; [0.005, 0], [0, 0]]; 
////////////////////////////////////////////////////
for i=2:15
    vOffsetPoints($+1) = OffsetPolylines(vOffsetPoints($),  vORBM2, mDoC_OffsetComponents);
    //vOffsetPoints($) = SlicePolylines(vOffsetPoints($), plBoundary, %F);
end

for i=1:15 
    vOffsetPoints(i) = SlicePolylines(vOffsetPoints(i), plBoundary, %T); 
end


pGrooveProfile = scf();
axGrooveProfile = gca();
SuperPlot(vOffsetPoints, list('b--', 'r--'));
SuperPlot(list(plWithRad), list('b--'));
//SuperPlot(list(plBoundary), list('b--'));
axGrooveProfile.isoview = "on"

