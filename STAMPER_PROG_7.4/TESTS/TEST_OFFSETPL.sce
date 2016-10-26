stacksize('max')

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
exec('DrawPolyline.sci');
exec('RadOutsideCorners.sci');
exec('IROffsetPolyline.sci');
exec('RemoveSharpCorners.sci');
exec('RemoveKnots.sci');
exec('DuperPlot.sci');
exec('RemoveInvertedCircles.sci');
exec('FwdSelfIntSmoothing.sci');

//  rectangle selection
clf();  // erase/create window
a=gca();a.data_bounds=[0 0;.100 .100];//set user coordinates
a.isoview = "on"
xtitle(" Draw a Polyline ") //add a title

listMPOR = list([%pi / 6, %pi / 2; %pi / 2, vStartFix(1); vStartFix; vStartFix(2), %pi] + fToolAngle(1)); //Tool Regime angular boundary matrix
listMPOC_FIN = list([[0.010, 0], [0, 0]; [0.010, 0], [0, 0]; [0.010, 0], [0, 0]; [0.010, 0], [0, 0]]);

plA = DrawPolyline(a);
//plB = DrawPolyline(a);

//plC = SlicePolyline(plA, plB, %T);


plC = OffsetPolyline(plA, listMPOR(1),listMPOC_FIN(1));
DuperPlot(plC)
