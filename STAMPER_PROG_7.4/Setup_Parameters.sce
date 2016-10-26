clear

//Load Raw Points from File
plPoints = csvRead("POINTS_16001_160409.csv", ",");  //Load Point file
plPoints(:,1) = -plPoints(:,1);  //Flip Point X-values to correspond with cutting on the left side of SPDT machine (CCW rotation)
plPoints = plPoints($:-1:1,:);  //Reverse the order of the points

//Load Included Functions///////////
exec('LoadIncluded.sce');
clc

////Define DoC Offset Regimes ////////////////////////////////////////////
//vStartFix = [.51 - fToolAngle(1), .53 - fToolAngle(1)];
//listMPOR = list([%pi / 6, 5*%pi / 6; 5*%pi / 6, vStartFix(1); vStartFix; vStartFix(2), %pi] + fToolAngle(1)); //Tool Regime angular boundary matrix
////listMPOR = list([%pi / 6, %pi / 2; %pi / 2, vStartFix(1); vStartFix; vStartFix(2), %pi] + fToolAngle(1)); //Tool Regime angular boundary matrix
//listMPOR(2) = listMPOR(1);
////listMPOR(3) = listMPOR(1);
////listMPOR(4) = listMPOR(1);
////listMPOR(5) = listMPOR(1);
//
//////Offsets for Roughing Cut Multipass (Brass)
////listMPOC_FIN = list([[.005, 0], [0, 0]; [.005, 0], [0, 0]; [.005, 0], [0, 0]; [.005, 0], [0, 0]]);
////listMPOC_FIN($+1) = [[.010, 0], [0, 0]; [.005, 0], [0, 0]; [.010, 0], [0, 0]; [.005, 0], [0, 0]];
////listMPOC_FIN($+1) = [[0.075, 0], [0, 0]; [0.015, 0], [0, 0]; [0.075, 0], [0, 0]; [0.015, 0], [0, 0]];
////
//////Offsets for final cut[s]
////listMPOC_FIN = list([[0, 0], [0, 0]; [0, 0], [0, 0]; [0, 0], [0, 0]; [0, 0], [0, 0]]);
////listMPOC_FIN($+1) = [[10, 0], [0, 0]; [10, 0], [0, 0]; [10, 0], [0, 0]; [10, 0], [0, 0]];
//
////Offsets for Roughing Cut Multipass (Ni)
//listMPOC_FIN = list([[.050, 0], [0, 0]; [.020, 0], [0, 0]; [.050, 0], [0, 0]; [.020, 0], [0, 0]]);
//listMPOC_FIN($+1) = [[0.020, 0], [0, 0]; [0.010, 0], [0, 0]; [0.020, 0], [0, 0]; [0.010, 0], [0, 0]];

