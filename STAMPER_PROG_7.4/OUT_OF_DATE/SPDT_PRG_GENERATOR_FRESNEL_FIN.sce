exec('Setup_Parameters_Finish.sce');

//Roughing Cut/////////////////////////////////////////////////////////////
//listCutPath = list(list(OffsetPolyline(vPoints, vNormalOffsetRegime, mNiUndersizeOffsetComponents))); //Establish ending profile
listCutPath = list(OffsetPolyline(vPoints, vNormalOffsetRegime, mNiUndersizeOffsetComponents)); //Establish ending profile

plBoundWithRad = AddInsideRad(listCutPath(1), vORBM, mCutterCompOffsetComponents);

plBoundWithRad = [plBoundWithRad(1,:) + [0 1]; plBoundWithRad(1:$,:)];

//plBoundary = [-234 -2; -234 .02; 1 .02];


pGrooveProfile = scf();
axGrooveProfile = gca();
axGrooveProfile.isoview = "on"

SuperPlot(list(listCutPath, plBoundWithRad), list('b--'))

[listCutPath, iLevelIndicies] = MultiOffsetToBoundary(listCutPath, listMultiPassOffsetRegimes, listMultiPassOffsetComponents, plBoundWithRad, 1);


//for i=2:10
//    tempOffsetComponents = listMultiPassOffsetComponents(min(i-1, size(listMultiPassOffsetComponents)));
//    listCutPath($+1) = OffsetPolylines(listCutPath($), vMultiPassOffsetRegimes, tempOffsetComponents); 
//end
//
//for i=size(listCutPath):-1:1
//    listTemp = SlicePolylines(listCutPath(i), plBoundary, %T);
//    if isempty(listTemp) then
//        listCutPath(i) = null();
//    else
//        listCutPath(i) = listTemp;
//    end
//    disp(i);
//end
//
//i = 1;
//bOffsetComplete = %F
//while ~bOffsetComplete
//    
//end

//pause
//listCutPathFlat = FlattenPolylineList(listCutPath);
//listCutPathFlat = ExtendEndPointsToZ(listCutPathFlat, .1);

//pGrooveProfile = scf();
//axGrooveProfile = gca();
//SuperPlot(listCutPath, list('b--', 'r--'));
//SuperPlot(list(plWithRad), list('b--'));
//SuperPlot(list(plBoundary), list('b--'));
//axGrooveProfile.isoview = "on"

plTooPath = BuildG_Code(listCutPath);

axGrooveProfile.data_bounds=[min(plTooPath(:,1)),min(plTooPath(:,2));max(plTooPath(:,1)),max(plTooPath(:,2))];
axGrooveProfile.isoview = "on"
