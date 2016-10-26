//stacksize('max')

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
exec('WeavePolylines.sci');

//  rectangle selection
clf();  // erase/create window
a=gca();a.data_bounds=[0 0;100 100];//set user coordinates
a.isoview = "on"
xtitle(" Draw Twp Poly Lines ") //add a title

plA = DrawPolyline(a);
plB = DrawPolyline(a);

plC = WeavePolylines(plA, plB, %F);

SuperPlot(list(plC), list('b--'))
