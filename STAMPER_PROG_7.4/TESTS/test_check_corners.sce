//Load the points on your own

N = size(points,1);
j = 1;
for i = 2:N-1
    lnA = points(i-1:i, :);
    lnB = points(i:i+1, :);

    vA(j,1:2) = lnA(2, :) - lnA(1,:);
    vB(j,1:2) = lnB(2, :) - lnB(1,:);

    fAlpha(j) = atan(vA(j, 2) / vA(j, 1));
    fBeta(j) = atan(vB(j, 2) / vB(j, 1));

    fCornerAngle(j) = abs(fAlpha(j) + fBeta(j));

    bInsideCorner(j) = 1 == sign(det([vA(j, 1:2); vB(j, 1:2)]));
    
    j = j + 1;
end



fCornerAngle = fCornerAngle * (180 / %pi);
fAlpha = fAlpha * (180 / %pi);
fBeta = fBeta * (180 / %pi);
