clc
fToolAngle = -85*%pi/180;
fToolIncludedAngle = 60*%pi/180;
fA = 45 * %pi/180;
vA = [cos(fA) sin(fA)];
//vA = [1, 1]
sReg = GetToolRegime(fToolAngle, fToolIncludedAngle, vA, "LEFT")
disp(sReg)
