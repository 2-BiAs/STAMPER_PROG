//Load Raw Points from File
plPoints = csvRead("POINTS_16001_160409.csv", ",");  //Load Point file
plPoints(:,1) = -plPoints(:,1);  //Flip Point X-values to correspond with cutting on the left side of SPDT machine (CCW rotation)
plPoints = plPoints($:-1:1,:);  //Reverse the order of the points
